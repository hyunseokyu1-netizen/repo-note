import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repo_note/core/providers.dart';
import 'package:repo_note/core/storage/app_database.dart';
import 'package:repo_note/core/storage/local_file_cache.dart';
import 'package:repo_note/core/storage/sync_enums.dart';
import 'package:repo_note/features/auth/presentation/session_controller.dart';
import 'package:repo_note/features/editor/presentation/editor_page.dart';
import 'package:repo_note/features/file_browser/data/notes_repository.dart';
import 'package:repo_note/l10n/gen/app_localizations.dart';
import 'package:repo_note/screenshots/fake_github_api.dart';

final _vault = VaultConfig(
  id: 'vault-1',
  owner: 'demo-user',
  repository: 'obsidian-notes',
  repositoryId: 1,
  branch: 'main',
  rootPath: '',
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

class _FakeSession extends SessionController {
  @override
  Future<SessionState> build() async =>
      SessionState(hasToken: true, vault: _vault);
}

/// 문단마다 번호가 달라 어디를 보고 있는지 식별할 수 있는 긴 문서.
final _doc = [
  '# 긴 문서',
  for (var i = 1; i <= 80; i++)
    i % 10 == 0 ? '## 섹션 $i' : '문단 $i 번의 **본문** 내용입니다. 조금 길게 씁니다.',
].join('\n\n');

/// 화면 위쪽(앱바 아래 [from]~[to]px)에 보이는 "문단 N"의 번호들.
List<int> _visibleParagraphNumbers(
  WidgetTester tester,
  Finder scope, {
  double from = 80,
  double to = 330,
}) {
  final numbers = <int>[];
  for (final e
      in find
          .descendant(of: scope, matching: find.byType(RichText))
          .evaluate()) {
    final box = e.renderObject! as RenderParagraph;
    final y = box.localToGlobal(Offset.zero).dy;
    if (y < from || y > to) continue;
    final m = RegExp(r'문단 (\d+) 번').firstMatch(box.text.toPlainText());
    if (m != null) numbers.add(int.parse(m.group(1)!));
  }
  return numbers..sort();
}

int _editTopParagraph(WidgetTester tester) {
  final editable = tester.renderObject<RenderEditable>(
    find.byElementPredicate((e) => e.renderObject is RenderEditable).last,
  );
  final offset = editable
      .getPositionForPoint(editable.localToGlobal(const Offset(0, 4)))
      .offset;
  final m = RegExp(r'문단 (\d+) 번').firstMatch(_doc.substring(offset));
  return int.parse(m!.group(1)!);
}

void main() {
  testWidgets('보기↔편집 전환 시 읽던 곳이 유지되고, 보기 모드에서 글자를 선택할 수 있다', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final tempDir = Directory.systemTemp.createTempSync('repo_note_editor');
    addTearDown(() async {
      await db.close();
      tempDir.deleteSync(recursive: true);
    });

    final fileId = NotesRepository.fileIdFor(_vault.id, 'long.md');
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        localFileCacheProvider.overrideWithValue(
          LocalFileCache(baseDir: tempDir),
        ),
        gitHubApiClientProvider.overrideWithValue(
          FakeGitHubApiClient(
            tree: {
              '': ['long.md'],
            },
            contents: {'long.md': _doc},
          ),
        ),
        sessionControllerProvider.overrideWith(_FakeSession.new),
      ],
    );
    addTearDown(container.dispose);

    await tester.runAsync(() async {
      await db.upsertFile(
        NoteFilesCompanion(
          id: Value(fileId),
          vaultId: Value(_vault.id),
          path: const Value('long.md'),
          name: const Value('long.md'),
          syncStatus: const Value(SyncStatus.synced),
        ),
      );
      await container.read(sessionControllerProvider.future);
    });

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: EditorPage(fileId: fileId),
        ),
      ),
    );
    for (var i = 0; i < 20 && find.byType(Markdown).evaluate().isEmpty; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump();
    }
    expect(find.byType(Markdown), findsOneWidget);

    // ---- 보기 모드에서 글자 선택이 가능하다 ----
    expect(find.byType(SelectionArea), findsOneWidget);
    // 문단 글자 위(왼쪽 위에서 조금 안쪽)를 길게 누른다.
    await tester.pump(const Duration(milliseconds: 500));
    final press = await tester.startGesture(
      tester.getTopLeft(find.textContaining('문단 2 번')) + const Offset(40, 10),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));
    await press.up();
    await tester.pumpAndSettle();
    expect(find.text('Copy'), findsOneWidget);
    await tester.tapAt(const Offset(5, 300));
    await tester.pumpAndSettle();

    // ---- 보기 모드에서 중간까지 읽는다 ----
    await tester.drag(find.byType(Markdown), const Offset(0, -2500));
    await tester.pumpAndSettle();
    final reading = _visibleParagraphNumbers(tester, find.byType(Markdown));
    expect(reading, isNotEmpty);
    expect(reading.first, greaterThan(20));

    // ---- 편집으로 전환: 문서 처음이 아니라 읽던 곳이 떠야 한다 ----
    await tester.tap(find.byTooltip('Edit'));
    await tester.pump();
    await tester.pump();
    await tester.pump();
    final editTop = _editTopParagraph(tester);
    expect(
      (editTop - reading.first).abs(),
      lessThanOrEqualTo(2),
      reason: '보기에서 문단 ${reading.first} 근처를 읽고 있었는데 편집은 문단 $editTop',
    );

    // ---- 다시 보기로 전환: 같은 곳으로 돌아온다 ----
    await tester.tap(find.byTooltip('Preview'));
    await tester.pump();
    await tester.pump();
    await tester.pump();
    expect(find.byType(Markdown), findsOneWidget);
    final back = _visibleParagraphNumbers(tester, find.byType(Markdown));
    expect(back, isNotEmpty);
    expect(
      (back.first - editTop).abs(),
      lessThanOrEqualTo(2),
      reason: '편집에서 문단 $editTop 근처였는데 보기는 문단 ${back.first}',
    );

    // 화면을 닫으며 남는 저장 작업 정리
    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump(const Duration(seconds: 1));
  });
}
