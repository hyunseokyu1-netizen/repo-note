import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/network/github_api_client.dart';
import '../../../core/providers.dart';
import '../../../core/storage/app_database.dart';
import '../../../core/storage/local_file_cache.dart';
import '../../../core/storage/sync_enums.dart';
import '../../../core/utils/file_name_validator.dart';
import '../../../core/utils/github_content_codec.dart';
import '../../editor/domain/opened_note.dart';
import '../domain/browser_entry.dart';

/// 노트 파일의 조회·생성·수정·삭제를 담당하는 Repository.
/// UI는 이 계층을 통해서만 GitHub API와 로컬 DB에 접근한다.
class NotesRepository {
  NotesRepository({
    required this._db,
    required this._api,
    required this._cache,
  });

  final AppDatabase _db;
  final GitHubApiClient _api;
  final LocalFileCache _cache;

  static String fileIdFor(String vaultId, String path) =>
      sha1.convert(utf8.encode('$vaultId:$path')).toString();

  // ---------- 탐색 ----------

  /// 서버에서 폴더 콘텐츠를 조회하고 Markdown 파일 메타데이터를 DB에 반영한다.
  /// [dirPath]는 저장소 루트 기준 전체 경로.
  Future<List<BrowserEntry>> listRemote(
    VaultConfig vault,
    String dirPath,
  ) async {
    final entries = await _api.listContents(
      vault.owner,
      vault.repository,
      dirPath,
      vault.branch,
    );

    final result = <BrowserEntry>[];
    for (final e in entries) {
      if (e.isDir) {
        result.add(BrowserEntry(name: e.name, fullPath: e.path, isDir: true));
        continue;
      }
      if (!e.isFile) continue;
      if (!e.name.toLowerCase().endsWith('.md')) {
        // Markdown 외 파일은 메타데이터를 저장하지 않고 표시만 지원한다.
        result.add(BrowserEntry(name: e.name, fullPath: e.path, isDir: false));
        continue;
      }
      final id = fileIdFor(vault.id, e.path);
      final existing = await _db.getFile(id);
      if (existing == null) {
        await _db.upsertFile(
          NoteFilesCompanion(
            id: Value(id),
            vaultId: Value(vault.id),
            path: Value(e.path),
            name: Value(e.name),
            remoteSha: Value(e.sha),
            syncStatus: const Value(SyncStatus.synced),
          ),
        );
      } else if (existing.syncStatus == SyncStatus.synced) {
        // 동기화된 파일만 서버 SHA를 갱신 (편집 중 파일의 상태는 유지)
        await _db.upsertFile(
          existing.toCompanion(true).copyWith(remoteSha: Value(e.sha)),
        );
      }
      final row = await _db.getFile(id);
      result.add(
        BrowserEntry(
          name: e.name,
          fullPath: e.path,
          isDir: false,
          fileId: id,
          syncStatus: row?.syncStatus,
          localUpdatedAt: row?.localUpdatedAt,
        ),
      );
    }

    // 서버 목록에 없는 로컬 전용/삭제 대기 파일 병합
    final locals = await _listLocalFiles(vault, dirPath);
    final remotePaths = result.map((e) => e.fullPath).toSet();
    for (final l in locals) {
      if (!remotePaths.contains(l.fullPath)) result.add(l);
    }
    return result;
  }

  /// 오프라인용: 로컬 DB 메타데이터에서 폴더 내용을 구성한다.
  Future<List<BrowserEntry>> listLocal(
    VaultConfig vault,
    String dirPath,
  ) async {
    final files = await _db.filesInVault(vault.id);
    final prefix = dirPath.isEmpty ? '' : '$dirPath/';
    final result = <BrowserEntry>[];
    final dirs = <String>{};

    for (final f in files) {
      if (f.isDeletedLocally) continue;
      if (!f.path.startsWith(prefix)) continue;
      final rest = f.path.substring(prefix.length);
      if (rest.isEmpty) continue;
      final slash = rest.indexOf('/');
      if (slash < 0) {
        result.add(
          BrowserEntry(
            name: f.name,
            fullPath: f.path,
            isDir: false,
            fileId: f.id,
            syncStatus: f.syncStatus,
            localUpdatedAt: f.localUpdatedAt,
          ),
        );
      } else {
        dirs.add(rest.substring(0, slash));
      }
    }
    for (final d in dirs) {
      result.add(
        BrowserEntry(
          name: d,
          fullPath: FileNameValidator.joinPath(dirPath, d),
          isDir: true,
        ),
      );
    }
    return result;
  }

  Future<List<BrowserEntry>> _listLocalFiles(
    VaultConfig vault,
    String dirPath,
  ) async {
    final all = await listLocal(vault, dirPath);
    return all.where((e) => !e.isDir).toList();
  }

  // ---------- 열기 ----------

  Future<OpenedNote> openFile(VaultConfig vault, String fileId) async {
    final file = await _db.getFile(fileId);
    if (file == null) throw const NotFoundFailure();
    await _db.touchRecent(fileId);

    final draft = await _db.getDraft(fileId);

    // 수정 중인 초안 또는 충돌 상태면 로컬 우선
    if (draft != null &&
        (draft.isDirty || file.syncStatus == SyncStatus.conflict)) {
      return OpenedNote(
        file: file,
        content: draft.content,
        baseSha: draft.baseSha,
        status: file.syncStatus,
        fromLocal: true,
      );
    }

    // 서버 원문 로드 시도
    try {
      final dto = await _api.getFile(
        vault.owner,
        vault.repository,
        file.path,
        vault.branch,
      );
      final content = GitHubContentCodec.decode(dto.contentBase64);
      final cachePath = await _cache.write(vault.id, file.path, content);
      await _db.upsertDraft(
        NoteDraftsCompanion(
          fileId: Value(fileId),
          content: Value(content),
          baseSha: Value(dto.sha),
          updatedAt: Value(DateTime.now()),
          isDirty: const Value(false),
        ),
      );
      await _db.upsertFile(
        file
            .toCompanion(true)
            .copyWith(
              remoteSha: Value(dto.sha),
              localContentPath: Value(cachePath),
              syncStatus: const Value(SyncStatus.synced),
            ),
      );
      final updated = await _db.getFile(fileId);
      return OpenedNote(
        file: updated!,
        content: content,
        baseSha: dto.sha,
        status: SyncStatus.synced,
        fromLocal: false,
      );
    } on AppFailure {
      // 오프라인/오류: 초안 → 파일 캐시 순으로 복구
      if (draft != null) {
        return OpenedNote(
          file: file,
          content: draft.content,
          baseSha: draft.baseSha,
          status: file.syncStatus,
          fromLocal: true,
        );
      }
      final cached = await _cache.read(vault.id, file.path);
      if (cached != null) {
        return OpenedNote(
          file: file,
          content: cached,
          baseSha: file.remoteSha,
          status: file.syncStatus,
          fromLocal: true,
        );
      }
      rethrow;
    }
  }

  // ---------- 초안 저장 ----------

  /// 편집 내용을 로컬에 저장한다. 네트워크 요청보다 항상 먼저 실행된다.
  Future<void> saveDraft(
    VaultConfig vault,
    String fileId,
    String content,
  ) async {
    final file = await _db.getFile(fileId);
    if (file == null) throw const NotFoundFailure();
    final existing = await _db.getDraft(fileId);
    final now = DateTime.now();
    final cachePath = await _cache.write(vault.id, file.path, content);
    await _db.upsertDraft(
      NoteDraftsCompanion(
        fileId: Value(fileId),
        content: Value(content),
        baseSha: Value(existing?.baseSha ?? file.remoteSha),
        updatedAt: Value(now),
        isDirty: const Value(true),
      ),
    );
    final keepStatus =
        file.syncStatus == SyncStatus.conflict ||
        file.syncStatus == SyncStatus.uploading;
    await _db.upsertFile(
      file
          .toCompanion(true)
          .copyWith(
            localContentPath: Value(cachePath),
            localUpdatedAt: Value(now),
            syncStatus: keepStatus
                ? null
                : Value(
                    file.remoteSha == null
                        ? SyncStatus.localOnly
                        : SyncStatus.pendingUpload,
                  ),
          ),
    );
  }

  // ---------- 생성 ----------

  /// 새 Markdown 파일을 로컬에 생성한다. 서버 반영은 SyncCoordinator가 수행한다.
  Future<NoteFile> createLocalFile(
    VaultConfig vault,
    String dirPath,
    String rawName,
  ) async {
    final error = FileNameValidator.validate(rawName);
    if (error != null) throw ValidationFailure(error);
    final name = FileNameValidator.ensureMarkdownExtension(rawName);
    final path = FileNameValidator.joinPath(dirPath, name);
    final id = fileIdFor(vault.id, path);

    final existing = await _db.getFile(id);
    if (existing != null && !existing.isDeletedLocally) {
      throw const ValidationFailure(ValidationErrorKind.duplicateName);
    }

    final now = DateTime.now();
    await _db.upsertFile(
      NoteFilesCompanion(
        id: Value(id),
        vaultId: Value(vault.id),
        path: Value(path),
        name: Value(name),
        remoteSha: const Value(null),
        localUpdatedAt: Value(now),
        syncStatus: const Value(SyncStatus.localOnly),
        isDeletedLocally: const Value(false),
      ),
    );
    await _db.upsertDraft(
      NoteDraftsCompanion(
        fileId: Value(id),
        content: const Value(''),
        baseSha: const Value(null),
        updatedAt: Value(now),
        isDirty: const Value(true),
      ),
    );
    return (await _db.getFile(id))!;
  }

  // ---------- 삭제 ----------

  /// 파일 삭제를 예약한다. 서버 반영 전까지 Tombstone 상태로 남긴다.
  Future<void> markDelete(String fileId) async {
    final file = await _db.getFile(fileId);
    if (file == null) return;
    if (file.remoteSha == null) {
      // 서버에 없는 로컬 전용 파일은 즉시 삭제
      await _cache.delete(file.vaultId, file.path);
      await _db.deleteDraft(fileId);
      await _db.deleteJobsForFile(fileId);
      await _db.deleteFileRow(fileId);
      return;
    }
    await _db.upsertFile(
      file
          .toCompanion(true)
          .copyWith(
            isDeletedLocally: const Value(true),
            syncStatus: const Value(SyncStatus.pendingDelete),
          ),
    );
  }

  // ---------- 이름 변경 ----------

  /// GitHub Contents API 특성상 "새 경로 생성 → 기존 경로 삭제"로 처리한다.
  /// 온라인 상태에서만 지원하며 부분 실패 시 명확한 메시지를 던진다.
  Future<void> rename(
    VaultConfig vault,
    String fileId,
    String rawNewName,
  ) async {
    final error = FileNameValidator.validate(rawNewName);
    if (error != null) throw ValidationFailure(error);

    final file = await _db.getFile(fileId);
    if (file == null) throw const NotFoundFailure();

    final newName = FileNameValidator.ensureMarkdownExtension(rawNewName);
    final slash = file.path.lastIndexOf('/');
    final dir = slash < 0 ? '' : file.path.substring(0, slash);
    final newPath = FileNameValidator.joinPath(dir, newName);
    await _movePath(vault, file.path, newPath);
  }

  // ---------- 이동 (드래그 앤 드롭) ----------

  /// 파일을 [targetDir] 폴더로 옮긴다. 파일명은 유지한다.
  /// [targetDir]가 저장소 루트면 빈 문자열을 넘긴다.
  Future<void> moveToFolder(
    VaultConfig vault,
    String fileId,
    String targetDir,
  ) async {
    final file = await _db.getFile(fileId);
    if (file == null) throw const NotFoundFailure();
    final newPath = FileNameValidator.joinPath(targetDir, file.name);
    await _movePath(vault, file.path, newPath);
  }

  /// 폴더 안의 모든 파일 경로를 재귀적으로 수집한다 (서버 기준).
  Future<List<String>> filesUnder(VaultConfig vault, String folderPath) async {
    final result = <String>[];
    Future<void> walk(String dir) async {
      final entries = await _api.listContents(
        vault.owner,
        vault.repository,
        dir,
        vault.branch,
      );
      for (final e in entries) {
        if (e.isDir) {
          await walk(e.path);
        } else if (e.isFile) {
          result.add(e.path);
        }
      }
    }

    await walk(folderPath);
    return result;
  }

  /// 폴더를 [targetParentDir] 아래로 옮긴다. 하위 파일을 하나씩 재생성·삭제한다.
  /// [files]를 미리 넘기면 다시 조회하지 않는다. 이동한 파일 수를 반환한다.
  Future<int> moveFolder(
    VaultConfig vault,
    String folderPath,
    String targetParentDir, {
    List<String>? files,
  }) async {
    final folderName = folderPath.contains('/')
        ? folderPath.substring(folderPath.lastIndexOf('/') + 1)
        : folderPath;
    final newFolderPath = FileNameValidator.joinPath(
      targetParentDir,
      folderName,
    );
    if (newFolderPath == folderPath) return 0;
    // 자기 자신이나 하위 폴더로는 옮길 수 없다.
    if (targetParentDir == folderPath ||
        targetParentDir.startsWith('$folderPath/')) {
      throw const ValidationFailure(ValidationErrorKind.moveIntoSelf);
    }

    final list = files ?? await filesUnder(vault, folderPath);
    for (final oldPath in list) {
      final rel = oldPath.substring(folderPath.length); // 앞에 '/' 포함
      await _movePath(vault, oldPath, '$newFolderPath$rel');
    }
    return list.length;
  }

  /// 파일을 [oldPath]에서 [newPath]로 옮기는 공통 로직 (이름 변경/이동 공용).
  /// GitHub Contents API 특성상 "새 경로 생성 → 기존 경로 삭제"로 처리한다.
  /// DB에 없는 파일(미로드 하위 파일)도 서버에서 직접 내용을 받아 처리한다.
  Future<void> _movePath(
    VaultConfig vault,
    String oldPath,
    String newPath,
  ) async {
    if (newPath == oldPath) return;

    final oldId = fileIdFor(vault.id, oldPath);
    final newId = fileIdFor(vault.id, newPath);
    final oldFile = await _db.getFile(oldId);

    final dup = await _db.getFile(newId);
    if (dup != null && !dup.isDeletedLocally) {
      throw const ValidationFailure(ValidationErrorKind.duplicateName);
    }

    final newName = newPath.contains('/')
        ? newPath.substring(newPath.lastIndexOf('/') + 1)
        : newPath;

    // 현재 내용 확보: 초안 → 캐시 → 서버
    final draft = await _db.getDraft(oldId);
    String? content = draft?.content;
    content ??= await _cache.read(vault.id, oldPath);
    if (content == null) {
      final dto = await _api.getFile(
        vault.owner,
        vault.repository,
        oldPath,
        vault.branch,
      );
      content = GitHubContentCodec.decode(dto.contentBase64);
    }

    // 삭제에 쓸 기존 SHA (DB → 서버 순)
    final oldSha =
        oldFile?.remoteSha ??
        await _api.getFileSha(
          vault.owner,
          vault.repository,
          oldPath,
          vault.branch,
        );

    // 1) 새 경로에 생성
    final put = await _api.putFile(
      owner: vault.owner,
      repo: vault.repository,
      path: newPath,
      message: 'Move $oldPath to $newPath from mobile',
      contentBase64: GitHubContentCodec.encode(content),
      branch: vault.branch,
    );

    final now = DateTime.now();
    final newCachePath = await _cache.write(vault.id, newPath, content);
    await _db.upsertFile(
      NoteFilesCompanion(
        id: Value(newId),
        vaultId: Value(vault.id),
        path: Value(newPath),
        name: Value(newName),
        remoteSha: Value(put.contentSha),
        localContentPath: Value(newCachePath),
        localUpdatedAt: Value(now),
        remoteUpdatedAt: Value(now),
        syncStatus: const Value(SyncStatus.synced),
      ),
    );
    await _db.upsertDraft(
      NoteDraftsCompanion(
        fileId: Value(newId),
        content: Value(content),
        baseSha: Value(put.contentSha),
        updatedAt: Value(now),
        isDirty: const Value(false),
      ),
    );

    // 2) 기존 경로 삭제 (서버에 존재하는 경우)
    if (oldSha != null) {
      try {
        await _api.deleteFile(
          owner: vault.owner,
          repo: vault.repository,
          path: oldPath,
          message: 'Move $oldPath to $newPath from mobile',
          sha: oldSha,
          branch: vault.branch,
        );
      } on AppFailure {
        // 부분 실패: 새 파일은 생성됨. 기존 파일은 삭제 대기로 남긴다.
        if (oldFile != null) {
          await _db.upsertFile(
            oldFile
                .toCompanion(true)
                .copyWith(
                  isDeletedLocally: const Value(true),
                  syncStatus: const Value(SyncStatus.pendingDelete),
                ),
          );
        }
        throw const ValidationFailure(ValidationErrorKind.renamePartialFailure);
      }
    }

    await _cache.delete(vault.id, oldPath);
    await _db.deleteDraft(oldId);
    await _db.deleteJobsForFile(oldId);
    await _db.deleteFileRow(oldId);
  }

  // ---------- 검색 ----------

  /// 파일명과 로컬 초안/캐시 본문에서 검색한다. 서버 검색 API를 사용하지 않는다.
  Future<List<SearchHit>> search(VaultConfig vault, String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];
    final files = await _db.filesInVault(vault.id);
    final hits = <SearchHit>[];
    for (final f in files) {
      if (f.isDeletedLocally) continue;
      String? snippet;
      var matched = f.name.toLowerCase().contains(q);
      final draft = await _db.getDraft(f.id);
      final content = draft?.content ?? await _cache.read(vault.id, f.path);
      if (content != null) {
        final idx = content.toLowerCase().indexOf(q);
        if (idx >= 0) {
          matched = true;
          final start = (idx - 30).clamp(0, content.length);
          final end = (idx + q.length + 50).clamp(0, content.length);
          snippet = content.substring(start, end).replaceAll('\n', ' ').trim();
        }
      }
      if (matched) {
        hits.add(
          SearchHit(fileId: f.id, name: f.name, path: f.path, snippet: snippet),
        );
      }
    }
    hits.sort((a, b) => a.name.compareTo(b.name));
    return hits;
  }
}

class SearchHit {
  const SearchHit({
    required this.fileId,
    required this.name,
    required this.path,
    this.snippet,
  });

  final String fileId;
  final String name;
  final String path;
  final String? snippet;
}

final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  return NotesRepository(
    db: ref.watch(databaseProvider),
    api: ref.watch(gitHubApiClientProvider),
    cache: ref.watch(localFileCacheProvider),
  );
});
