import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repo_note/core/storage/app_database.dart';
import 'package:repo_note/core/storage/sync_enums.dart';
import 'package:repo_note/features/editor/data/reading_state_store.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<void> addFile(String id, {String vaultId = 'vault-1'}) =>
      db.upsertFile(
        NoteFilesCompanion(
          id: Value(id),
          vaultId: Value(vaultId),
          path: Value('$id.md'),
          name: Value('$id.md'),
          syncStatus: const Value(SyncStatus.synced),
        ),
      );

  group('이어서 열 노트', () {
    test('노트를 열어둔 채 앱이 꺼지면 다음 실행에서 그 노트를 돌려준다', () async {
      await addFile('a');
      ReadingStateStore(db).setLastOpen('a');

      // 새 프로세스 = 새 스토어
      final next = ReadingStateStore(db);
      expect(await next.takeResumeTarget('vault-1'), 'a');
      // 프로세스당 한 번만
      expect(await next.takeResumeTarget('vault-1'), isNull);
    });

    test('목록으로 돌아간 뒤 꺼지면 자동으로 열지 않는다', () async {
      await addFile('a');
      final store = ReadingStateStore(db)..setLastOpen('a');
      store.clearLastOpenIf('a');

      expect(await ReadingStateStore(db).takeResumeTarget('vault-1'), isNull);
    });

    test('위키링크로 연 노트를 닫아도 원래 노트는 유지된다', () async {
      await addFile('a');
      await addFile('b');
      final store = ReadingStateStore(db)
        ..setLastOpen('a')
        ..setLastOpen('b')
        // b에서 뒤로 → a가 다시 보던 문서가 되고, 그 뒤 b 화면이 dispose된다
        ..setLastOpen('a');
      store.clearLastOpenIf('b');

      expect(await ReadingStateStore(db).takeResumeTarget('vault-1'), 'a');
    });

    test('삭제됐거나 다른 Vault의 노트는 무시한다', () async {
      ReadingStateStore(db).setLastOpen('gone');
      expect(await ReadingStateStore(db).takeResumeTarget('vault-1'), isNull);

      await addFile('other', vaultId: 'vault-2');
      ReadingStateStore(db).setLastOpen('other');
      expect(await ReadingStateStore(db).takeResumeTarget('vault-1'), isNull);
    });
  });

  test('노트별 스크롤 위치와 모드를 저장·복원한다', () async {
    final store = ReadingStateStore(db);
    expect(await store.position('a'), isNull);

    await store.savePosition(
      'a',
      const ReadingPosition(
        previewOffset: 1234.5,
        editOffset: 80,
        preview: false,
      ),
    );
    final pos = await ReadingStateStore(db).position('a');
    expect(pos!.previewOffset, 1234.5);
    expect(pos.editOffset, 80);
    expect(pos.preview, isFalse);
  });

  testWidgets('ResumableScrollController는 저장된 위치에서 시작하고 다시 붙어도 유지한다', (
    tester,
  ) async {
    final controller = ResumableScrollController()..lastOffset = 900;
    addTearDown(controller.dispose);

    Widget list() => MaterialApp(
      home: ListView(
        controller: controller,
        children: [
          for (var i = 0; i < 100; i++) SizedBox(height: 50, child: Text('$i')),
        ],
      ),
    );

    await tester.pumpWidget(list());
    expect(controller.position.pixels, 900);

    controller.jumpTo(1500);
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    expect(controller.hasClients, isFalse);

    await tester.pumpWidget(list());
    expect(controller.position.pixels, 1500);
  });
}
