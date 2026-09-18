import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repo_note/core/storage/app_database.dart';
import 'package:repo_note/core/storage/local_file_cache.dart';
import 'package:repo_note/core/storage/sync_enums.dart';
import 'package:repo_note/features/file_browser/data/notes_repository.dart';
import 'package:repo_note/screenshots/fake_github_api.dart';

void main() {
  late AppDatabase db;
  late Directory tempDir;
  late FakeGitHubApiClient api;
  late NotesRepository repo;

  final vault = VaultConfig(
    id: 'vault-1',
    owner: 'demo-user',
    repository: 'obsidian-notes',
    repositoryId: 1,
    branch: 'main',
    rootPath: '',
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    tempDir = await Directory.systemTemp.createTemp('repo_note_test');
    api = FakeGitHubApiClient(
      tree: {
        '': ['dir:inbox', 'dir:archive', 'root.md'],
        'inbox': ['note.md'],
        'archive': [],
      },
      contents: {'inbox/note.md': '# note'},
    );
    repo = NotesRepository(
      db: db,
      api: api,
      cache: LocalFileCache(baseDir: tempDir),
    );
  });

  tearDown(() async {
    await db.close();
    await tempDir.delete(recursive: true);
  });

  Future<Set<String>> localPaths() async =>
      (await db.filesInVault(vault.id)).map((f) => f.path).toSet();

  group('listRemote – 서버에서 사라진 파일 정리', () {
    test('PC에서 다른 폴더로 옮긴 노트는 목록 갱신 시 이전 위치에서 사라진다', () async {
      await repo.listRemote(vault, 'inbox');
      expect(await localPaths(), contains('inbox/note.md'));

      // PC에서 inbox/note.md → archive/note.md 로 이동 후 push
      api.tree['inbox'] = [];
      api.tree['archive'] = ['note.md'];

      final inbox = await repo.listRemote(vault, 'inbox');
      expect(inbox.map((e) => e.fullPath), isNot(contains('inbox/note.md')));
      expect(await localPaths(), isNot(contains('inbox/note.md')));

      final archive = await repo.listRemote(vault, 'archive');
      expect(archive.map((e) => e.fullPath), contains('archive/note.md'));
    });

    test('폴더째 옮긴 경우 상위 폴더 갱신 시 하위 파일 메타데이터도 정리된다', () async {
      await repo.listRemote(vault, 'inbox');
      expect(await localPaths(), contains('inbox/note.md'));

      // PC에서 inbox/ → archive/inbox/ 로 폴더 이동 후 push
      api.tree[''] = ['dir:archive', 'root.md'];
      api.tree['archive'] = ['dir:inbox'];
      api.tree['archive/inbox'] = ['note.md'];
      api.tree.remove('inbox');

      await repo.listRemote(vault, '');
      expect(await localPaths(), isNot(contains('inbox/note.md')));
    });

    test('수정 중인 초안이 있는 파일은 서버에 없어도 유지된다', () async {
      await repo.listRemote(vault, 'inbox');
      final id = NotesRepository.fileIdFor(vault.id, 'inbox/note.md');
      await repo.saveDraft(vault, id, '# edited locally');

      api.tree['inbox'] = [];

      final inbox = await repo.listRemote(vault, 'inbox');
      expect(inbox.map((e) => e.fullPath), contains('inbox/note.md'));
      expect(await localPaths(), contains('inbox/note.md'));
    });

    test('로컬 전용(미업로드) 파일은 서버에 없어도 유지된다', () async {
      await repo.createLocalFile(vault, 'inbox', 'draft');

      final inbox = await repo.listRemote(vault, 'inbox');
      expect(inbox.map((e) => e.fullPath), contains('inbox/draft.md'));
      final row = await db.getFileByPath(vault.id, 'inbox/draft.md');
      expect(row?.syncStatus, SyncStatus.localOnly);
    });

    test('삭제 대기 파일은 서버에 남아 있어도 목록에서 숨겨지고 DB에는 유지된다', () async {
      await repo.listRemote(vault, 'inbox');
      final id = NotesRepository.fileIdFor(vault.id, 'inbox/note.md');
      await repo.markDelete(id);

      await repo.listRemote(vault, 'inbox');
      final row = await db.getFile(id);
      expect(row?.syncStatus, SyncStatus.pendingDelete);
      expect(row?.isDeletedLocally, isTrue);
    });
  });

  test('markDelete: 로컬 전용 파일은 즉시 모든 흔적이 지워진다', () async {
    final file = await repo.createLocalFile(vault, '', 'temp');
    await db.upsertDraft(
      NoteDraftsCompanion(
        fileId: Value(file.id),
        content: const Value('x'),
        updatedAt: Value(DateTime.now()),
        isDirty: const Value(true),
      ),
    );
    await repo.markDelete(file.id);
    expect(await db.getFile(file.id), isNull);
    expect(await db.getDraft(file.id), isNull);
  });
}
