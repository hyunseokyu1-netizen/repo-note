import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/network/github_api_client.dart';
import '../../../core/providers.dart';
import '../../../core/storage/app_database.dart';
import '../../../core/storage/local_file_cache.dart';
import '../../../core/storage/sync_enums.dart';
import '../../../core/utils/github_content_codec.dart';
import '../../file_browser/data/notes_repository.dart';

/// 충돌 해결 화면에 표시할 정보.
class ConflictDetail {
  const ConflictDetail({
    required this.file,
    required this.localContent,
    required this.localUpdatedAt,
    required this.serverContent,
    required this.serverSha,
    required this.detectedAt,
  });

  final NoteFile file;
  final String localContent;
  final DateTime? localUpdatedAt;
  final String serverContent;
  final String serverSha;
  final DateTime detectedAt;
}

/// 충돌 해결 로직. 사용자 확인 없이는 어떤 버전도 덮어쓰지 않는다.
class ConflictResolver {
  ConflictResolver({
    required this._db,
    required this._api,
    required this._cache,
  });

  final AppDatabase _db;
  final GitHubApiClient _api;
  final LocalFileCache _cache;

  Future<ConflictDetail> loadDetail(String fileId) async {
    final file = await _db.getFile(fileId);
    final conflict = await _db.getConflict(fileId);
    final draft = await _db.getDraft(fileId);
    if (file == null || conflict == null) throw const NotFoundFailure();
    return ConflictDetail(
      file: file,
      localContent: draft?.content ?? '',
      localUpdatedAt: draft?.updatedAt,
      serverContent: conflict.serverContent,
      serverSha: conflict.serverSha,
      detectedAt: conflict.detectedAt,
    );
  }

  /// 서버 버전 사용: 로컬 초안을 서버 내용으로 교체한다.
  Future<void> useServerVersion(VaultConfig vault, String fileId) async {
    final detail = await loadDetail(fileId);
    final now = DateTime.now();
    await _cache.write(vault.id, detail.file.path, detail.serverContent);
    await _db.upsertDraft(
      NoteDraftsCompanion(
        fileId: Value(fileId),
        content: Value(detail.serverContent),
        baseSha: Value(detail.serverSha.isEmpty ? null : detail.serverSha),
        updatedAt: Value(now),
        isDirty: const Value(false),
      ),
    );
    await _db.upsertFile(
      detail.file
          .toCompanion(true)
          .copyWith(
            remoteSha: Value(
              detail.serverSha.isEmpty ? null : detail.serverSha,
            ),
            isDeletedLocally: const Value(false),
            syncStatus: const Value(SyncStatus.synced),
          ),
    );
    await _db.deleteConflict(fileId);
    await _db.deleteJobsForFile(fileId);
  }

  /// 내 버전으로 덮어쓰기: 사용자가 명시적으로 선택한 경우에만
  /// 최신 서버 SHA를 사용해 로컬 내용을 커밋한다.
  Future<void> overwriteWithMine(VaultConfig vault, String fileId) async {
    final detail = await loadDetail(fileId);
    final put = await _api.putFile(
      owner: vault.owner,
      repo: vault.repository,
      path: detail.file.path,
      message: 'Resolve conflict: keep local ${detail.file.path} from mobile',
      contentBase64: GitHubContentCodec.encode(detail.localContent),
      branch: vault.branch,
      sha: detail.serverSha.isEmpty ? null : detail.serverSha,
    );
    final now = DateTime.now();
    await _db.upsertDraft(
      NoteDraftsCompanion(
        fileId: Value(fileId),
        content: Value(detail.localContent),
        baseSha: Value(put.contentSha),
        updatedAt: Value(now),
        isDirty: const Value(false),
      ),
    );
    await _db.upsertFile(
      detail.file
          .toCompanion(true)
          .copyWith(
            remoteSha: Value(put.contentSha),
            remoteUpdatedAt: Value(now),
            isDeletedLocally: const Value(false),
            syncStatus: const Value(SyncStatus.synced),
          ),
    );
    await _db.deleteConflict(fileId);
    await _db.deleteJobsForFile(fileId);
  }

  /// 두 버전을 합친 새 파일 생성:
  /// 내 버전을 충돌 사본 파일로 저장하고, 원본은 서버 버전으로 되돌린다.
  /// 반환값은 생성된 사본 파일의 fileId.
  Future<String> createMergedCopy(VaultConfig vault, String fileId) async {
    final detail = await loadDetail(fileId);
    final slash = detail.file.path.lastIndexOf('/');
    final dir = slash < 0 ? '' : detail.file.path.substring(0, slash);
    final base = detail.file.name.toLowerCase().endsWith('.md')
        ? detail.file.name.substring(0, detail.file.name.length - 3)
        : detail.file.name;
    final stamp = DateFormat('yyyy-MM-dd-HHmmss').format(DateTime.now());

    // 같은 폴더 안에서 중복되지 않는 이름 생성
    var copyName = '$base-conflict-$stamp.md';
    var suffix = 1;
    while (await _db.getFileByPath(
          vault.id,
          dir.isEmpty ? copyName : '$dir/$copyName',
        ) !=
        null) {
      copyName = '$base-conflict-$stamp-$suffix.md';
      suffix++;
    }
    final copyPath = dir.isEmpty ? copyName : '$dir/$copyName';
    final copyId = NotesRepository.fileIdFor(vault.id, copyPath);

    final now = DateTime.now();
    final cachePath = await _cache.write(
      vault.id,
      copyPath,
      detail.localContent,
    );
    await _db.upsertFile(
      NoteFilesCompanion(
        id: Value(copyId),
        vaultId: Value(vault.id),
        path: Value(copyPath),
        name: Value(copyName),
        localContentPath: Value(cachePath),
        localUpdatedAt: Value(now),
        syncStatus: const Value(SyncStatus.localOnly),
      ),
    );
    await _db.upsertDraft(
      NoteDraftsCompanion(
        fileId: Value(copyId),
        content: Value(detail.localContent),
        updatedAt: Value(now),
        isDirty: const Value(true),
      ),
    );

    // 원본은 서버 버전으로 복원
    await useServerVersion(vault, fileId);
    return copyId;
  }
}

final conflictResolverProvider = Provider<ConflictResolver>((ref) {
  return ConflictResolver(
    db: ref.watch(databaseProvider),
    api: ref.watch(gitHubApiClientProvider),
    cache: ref.watch(localFileCacheProvider),
  );
});
