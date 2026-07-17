import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/network/github_api_client.dart';
import '../../../core/providers.dart';
import '../../../core/storage/app_database.dart';
import '../../../core/storage/local_file_cache.dart';
import '../../../core/storage/sync_enums.dart';
import '../../../core/utils/conflict_detector.dart';
import '../../../core/utils/github_content_codec.dart';
import '../domain/sync_result.dart';

abstract interface class SyncCoordinator {
  Future<SyncSummary> syncAll(VaultConfig vault, {bool manual});
  Future<SyncResult> syncFile(VaultConfig vault, String fileId);
  Future<void> enqueueUpload(String fileId);
  Future<void> enqueueDelete(String fileId);
}

/// 동기화 엔진. Pending 작업 조회, 파일별 직렬 처리, SHA 검사,
/// 업로드/삭제, Retry, 충돌 생성, DB 상태 갱신을 담당한다.
class SyncCoordinatorImpl implements SyncCoordinator {
  SyncCoordinatorImpl({
    required this._db,
    required this._api,
    required this._cache,
  });

  final AppDatabase _db;
  final GitHubApiClient _api;
  final LocalFileCache _cache;

  /// 동일 파일 중복 동기화 방지.
  final Set<String> _inProgress = {};
  bool _syncAllRunning = false;

  static const _maxRetry = 5;

  @override
  Future<void> enqueueUpload(String fileId) =>
      _enqueue(fileId, SyncOperation.upload);

  @override
  Future<void> enqueueDelete(String fileId) =>
      _enqueue(fileId, SyncOperation.delete);

  Future<void> _enqueue(String fileId, SyncOperation op) async {
    final existing = await _db.jobForFile(fileId);
    if (existing != null && existing.operation == op) return; // 중복 방지
    await _db.deleteJobsForFile(fileId);
    await _db.upsertJob(
      SyncJobsCompanion(
        id: Value(const Uuid().v4()),
        fileId: Value(fileId),
        operation: Value(op),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<SyncSummary> syncAll(VaultConfig vault, {bool manual = false}) async {
    if (_syncAllRunning) return const SyncSummary(skipped: 1);
    _syncAllRunning = true;
    try {
      final pending = await _db.pendingFiles(vault.id);
      var uploaded = 0, deleted = 0, conflicts = 0, failed = 0, skipped = 0;
      // 동시에 많은 요청을 보내지 않도록 파일별 순차 처리
      for (final file in pending) {
        if (!manual) {
          final job = await _db.jobForFile(file.id);
          final nextRetry = job?.nextRetryAt;
          if (nextRetry != null && nextRetry.isAfter(DateTime.now())) {
            skipped++;
            continue;
          }
          if ((job?.retryCount ?? 0) >= _maxRetry) {
            skipped++;
            continue;
          }
        }
        final result = await syncFile(vault, file.id);
        switch (result) {
          case SyncResult.uploaded:
            uploaded++;
          case SyncResult.deleted:
            deleted++;
          case SyncResult.conflict:
            conflicts++;
          case SyncResult.failed:
            failed++;
          case SyncResult.upToDate:
          case SyncResult.skipped:
            skipped++;
        }
      }
      return SyncSummary(
        uploaded: uploaded,
        deleted: deleted,
        conflicts: conflicts,
        failed: failed,
        skipped: skipped,
      );
    } finally {
      _syncAllRunning = false;
    }
  }

  @override
  Future<SyncResult> syncFile(VaultConfig vault, String fileId) async {
    if (_inProgress.contains(fileId)) return SyncResult.skipped;
    _inProgress.add(fileId);
    try {
      final file = await _db.getFile(fileId);
      if (file == null) return SyncResult.skipped;
      if (file.syncStatus == SyncStatus.conflict) return SyncResult.conflict;
      if (file.syncStatus == SyncStatus.pendingDelete ||
          file.isDeletedLocally) {
        return await _syncDelete(vault, file);
      }
      return await _syncUpload(vault, file);
    } finally {
      _inProgress.remove(fileId);
    }
  }

  Future<SyncResult> _syncUpload(VaultConfig vault, NoteFile file) async {
    final draft = await _db.getDraft(file.id);
    if (draft == null || !draft.isDirty) {
      if (file.syncStatus != SyncStatus.synced && file.remoteSha != null) {
        await _db.updateFileStatus(file.id, SyncStatus.synced);
      }
      return SyncResult.upToDate;
    }

    await _db.updateFileStatus(file.id, SyncStatus.uploading);
    try {
      // 업로드 직전 서버 SHA 재확인
      final serverSha = await _api.getFileSha(
        vault.owner,
        vault.repository,
        file.path,
        vault.branch,
      );

      if (ConflictDetector.isConflict(
        baseSha: draft.baseSha,
        serverSha: serverSha,
      )) {
        await _registerConflict(vault, file, serverSha);
        return SyncResult.conflict;
      }

      final put = await _api.putFile(
        owner: vault.owner,
        repo: vault.repository,
        path: file.path,
        message:
            '${draft.baseSha == null ? 'Create' : 'Update'} '
            '${file.path} from mobile',
        contentBase64: GitHubContentCodec.encode(draft.content),
        branch: vault.branch,
        sha: draft.baseSha,
      );

      final now = DateTime.now();
      await _db.upsertDraft(
        draft
            .toCompanion(true)
            .copyWith(
              baseSha: Value(put.contentSha),
              isDirty: const Value(false),
            ),
      );
      await _db.upsertFile(
        file
            .toCompanion(true)
            .copyWith(
              remoteSha: Value(put.contentSha),
              remoteUpdatedAt: Value(now),
              syncStatus: const Value(SyncStatus.synced),
            ),
      );
      await _db.deleteJobsForFile(file.id);
      return SyncResult.uploaded;
    } on ConflictFailure {
      final serverSha = await _safeServerSha(vault, file.path);
      await _registerConflict(vault, file, serverSha);
      return SyncResult.conflict;
    } on AppFailure catch (e) {
      return _handleFailure(file, e, SyncOperation.upload);
    }
  }

  Future<SyncResult> _syncDelete(VaultConfig vault, NoteFile file) async {
    try {
      final serverSha = await _api.getFileSha(
        vault.owner,
        vault.repository,
        file.path,
        vault.branch,
      );
      if (serverSha == null) {
        // 이미 서버에서 사라짐
        await _cleanupFile(file);
        return SyncResult.deleted;
      }
      if (file.remoteSha != null && serverSha != file.remoteSha) {
        // 삭제하려는 파일이 서버에서 변경됨 → 충돌
        await _registerConflict(vault, file, serverSha);
        return SyncResult.conflict;
      }
      await _api.deleteFile(
        owner: vault.owner,
        repo: vault.repository,
        path: file.path,
        message: 'Delete ${file.path} from mobile',
        sha: serverSha,
        branch: vault.branch,
      );
      await _cleanupFile(file);
      return SyncResult.deleted;
    } on ConflictFailure {
      final serverSha = await _safeServerSha(vault, file.path);
      await _registerConflict(vault, file, serverSha);
      return SyncResult.conflict;
    } on AppFailure catch (e) {
      return _handleFailure(file, e, SyncOperation.delete);
    }
  }

  Future<void> _cleanupFile(NoteFile file) async {
    await _cache.delete(file.vaultId, file.path);
    await _db.deleteDraft(file.id);
    await _db.deleteJobsForFile(file.id);
    await _db.deleteConflict(file.id);
    await _db.deleteFileRow(file.id);
  }

  Future<String?> _safeServerSha(VaultConfig vault, String path) async {
    try {
      return await _api.getFileSha(
        vault.owner,
        vault.repository,
        path,
        vault.branch,
      );
    } on AppFailure {
      return null;
    }
  }

  /// 충돌 등록: 서버 버전을 내려받아 보관하고 상태를 conflict로 바꾼다.
  /// 로컬 초안은 절대 삭제하지 않는다.
  Future<void> _registerConflict(
    VaultConfig vault,
    NoteFile file,
    String? serverSha,
  ) async {
    var serverContent = '';
    var sha = serverSha ?? '';
    if (serverSha != null) {
      try {
        final dto = await _api.getFile(
          vault.owner,
          vault.repository,
          file.path,
          vault.branch,
        );
        serverContent = GitHubContentCodec.decode(dto.contentBase64);
        sha = dto.sha;
      } on AppFailure {
        // 서버 본문 조회 실패 시에도 충돌 상태는 유지한다.
      }
    }
    await _db.upsertConflict(
      ConflictsCompanion(
        fileId: Value(file.id),
        serverSha: Value(sha),
        serverContent: Value(serverContent),
        detectedAt: Value(DateTime.now()),
      ),
    );
    await _db.updateFileStatus(file.id, SyncStatus.conflict);
    await _db.deleteJobsForFile(file.id);
  }

  /// 실패 처리: 401/403은 재시도하지 않고, 네트워크 오류는 지수 Backoff로 재시도.
  Future<SyncResult> _handleFailure(
    NoteFile file,
    AppFailure failure,
    SyncOperation op,
  ) async {
    final retriable = failure is NetworkFailure || failure is RateLimitFailure;
    if (!retriable) {
      await _db.updateFileStatus(file.id, SyncStatus.failed);
      await _db.deleteJobsForFile(file.id);
      return SyncResult.failed;
    }
    final job = await _db.jobForFile(file.id);
    final retryCount = (job?.retryCount ?? 0) + 1;
    final backoffSeconds = 30 * (1 << (retryCount - 1).clamp(0, 5));
    await _db.deleteJobsForFile(file.id);
    await _db.upsertJob(
      SyncJobsCompanion(
        id: Value(job?.id ?? const Uuid().v4()),
        fileId: Value(file.id),
        operation: Value(op),
        retryCount: Value(retryCount),
        lastErrorCode: Value(failure.code),
        createdAt: Value(job?.createdAt ?? DateTime.now()),
        nextRetryAt: Value(
          DateTime.now().add(Duration(seconds: backoffSeconds)),
        ),
      ),
    );
    await _db.updateFileStatus(
      file.id,
      op == SyncOperation.delete
          ? SyncStatus.pendingDelete
          : SyncStatus.pendingUpload,
    );
    return SyncResult.failed;
  }
}

final syncCoordinatorProvider = Provider<SyncCoordinator>((ref) {
  return SyncCoordinatorImpl(
    db: ref.watch(databaseProvider),
    api: ref.watch(gitHubApiClientProvider),
    cache: ref.watch(localFileCacheProvider),
  );
});
