import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repo_note/features/editor/presentation/find_in_note.dart';

void main() {
  group('findMatches', () {
    test('대소문자 구분 없이 모든 위치를 찾는다', () {
      final m = findMatches('Flutter flutter FLUTTER', 'flutter');
      expect(m.map((r) => r.start), [0, 8, 16]);
    });

    test('정규식 특수문자는 글자 그대로 찾는다', () {
      expect(findMatches('a.b a*b (x)', '(x)').single.start, 8);
      expect(findMatches('axb', 'a.b'), isEmpty);
    });

    test('빈 검색어는 결과가 없다', () {
      expect(findMatches('abc', ''), isEmpty);
    });
  });

  testWidgets('편집 모드: 일치 항목에 배경색을 입히고 현재 항목을 구분한다', (tester) async {
    final controller = FindHighlightController()..text = '사과 바나나 사과';
    addTearDown(controller.dispose);
    controller.setHighlights(findMatches(controller.text, '사과'), 1);

    late TextSpan span;
    await tester.pumpWidget(
      Builder(
        builder: (context) {
          span = controller.buildTextSpan(
            context: context,
            withComposing: false,
          );
          return const SizedBox();
        },
      ),
    );

    expect(span.toPlainText(), '사과 바나나 사과');
    final parts = span.children!.cast<TextSpan>();
    expect(parts.map((p) => p.text), ['사과', ' 바나나 ', '사과']);
    expect(parts[0].style!.backgroundColor, kFindMatchColor);
    expect(parts[1].style, isNull);
    expect(parts[2].style!.backgroundColor, kFindCurrentColor);
  });

  group('보기 모드 PreviewFindLayer', () {
    // 문단 60개 중 일부에만 "목표"가 들어 있다. 서식(굵게)·목록 안의 것도 포함.
    final data = [
      for (var i = 0; i < 60; i++)
        if (i == 5)
          '문단 $i **목표** 설정'
        else if (i == 30)
          '- 목록 $i 목표 하나, 목표 둘'
        else if (i == 55)
          '문단 $i 마지막 목표'
        else
          '문단 $i 내용',
    ].join('\n\n');

    Future<void> pump(
      WidgetTester tester, {
      required ScrollController scroll,
      required String query,
      required int index,
      required void Function(int, int) onResults,
    }) => tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            controller: scroll,
            padding: const EdgeInsets.all(16),
            child: PreviewFindLayer(
              query: query,
              data: data,
              index: index,
              scrollController: scroll,
              topInset: 16,
              onResults: onResults,
              child: MarkdownBody(data: data),
            ),
          ),
        ),
      ),
    );

    testWidgets('렌더링된 글자에서 개수를 세고 다음 항목으로 스크롤한다', (tester) async {
      final scroll = ScrollController();
      addTearDown(scroll.dispose);
      var count = -1;
      var index = -1;
      void onResults(int c, int i) {
        count = c;
        index = i;
      }

      await pump(
        tester,
        scroll: scroll,
        query: '목표',
        index: -1,
        onResults: onResults,
      );
      await tester.pump();

      // 굵게 1 + 목록 2 + 마지막 1
      expect(count, 4);
      expect(index, 0);
      expect(scroll.offset, 0); // 첫 항목은 이미 화면 안

      // 다음 항목(30번째 문단)은 화면 밖 → 스크롤된다
      await pump(
        tester,
        scroll: scroll,
        query: '목표',
        index: 1,
        onResults: onResults,
      );
      await tester.pump();
      expect(scroll.offset, greaterThan(0));
      expect(
        tester.getTopLeft(find.textContaining('목록 30')).dy,
        inInclusiveRange(0, 600),
      );

      final afterSecond = scroll.offset;
      await pump(
        tester,
        scroll: scroll,
        query: '목표',
        index: 3,
        onResults: onResults,
      );
      await tester.pump();
      expect(scroll.offset, greaterThan(afterSecond));
    });

    testWidgets('중간까지 읽던 상태에서 찾으면 보던 위치 이후의 항목부터 선택한다', (tester) async {
      final scroll = ScrollController();
      addTearDown(scroll.dispose);
      var count = -1;
      var index = -1;
      void onResults(int c, int i) {
        count = c;
        index = i;
      }

      await pump(
        tester,
        scroll: scroll,
        query: '',
        index: -1,
        onResults: onResults,
      );
      await tester.pump();
      expect(count, 0);
      expect(index, -1);

      scroll.jumpTo(600); // 5번째 문단은 이미 지나침
      await tester.pump();

      await pump(
        tester,
        scroll: scroll,
        query: '목표',
        index: -1,
        onResults: onResults,
      );
      await tester.pump();
      expect(count, 4);
      expect(index, 1);
    });

    testWidgets('없는 단어는 0건', (tester) async {
      final scroll = ScrollController();
      addTearDown(scroll.dispose);
      var count = -1;
      await pump(
        tester,
        scroll: scroll,
        query: '없는단어',
        index: -1,
        onResults: (c, _) => count = c,
      );
      await tester.pump();
      expect(count, 0);
    });
  });
}
