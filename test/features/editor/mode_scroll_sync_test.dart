import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repo_note/features/editor/presentation/mode_scroll_sync.dart';

/// 제목·목록·굵게·반복 문장이 섞인 60문단 문서.
final source = [
  '# 회의록',
  for (var i = 0; i < 60; i++)
    if (i % 10 == 0)
      '## 섹션 ${i ~/ 10}'
    else if (i % 10 == 3)
      '- 할 일 $i: **중요** 항목 정리'
    else if (i % 10 == 7)
      '같은 문장이 반복됩니다.'
    else
      '문단 $i 의 본문 내용입니다.',
].join('\n\n');

void main() {
  group('locateInSource (보기 → 편집)', () {
    test('화면 맨 위 글자를 원문에서 찾는다', () {
      final m = locateInSource(source, const [
        ScrollAnchor('문단 25 의 본문 내용입니다.', 12),
      ], 0.4);
      expect(source.substring(m!.offset), startsWith('문단 25 의'));
      expect(m.dy, 12);
    });

    test('서식이 끼어 전체가 안 맞으면 앞부분으로 찾는다', () {
      // 화면에는 "할 일 33: 중요 항목 정리", 원문에는 **중요**
      final m = locateInSource(source, const [
        ScrollAnchor('할 일 33: 중요 항목 정리', 0),
      ], 0.5);
      expect(source.substring(m!.offset), startsWith('할 일 33:'));
    });

    test('같은 글자가 여러 번 나오면 스크롤 진행률에 가까운 것을 고른다', () {
      const repeated = '같은 문장이 반복됩니다.';
      final early = locateInSource(source, const [
        ScrollAnchor(repeated, 0),
      ], 0.1)!.offset;
      final late = locateInSource(source, const [
        ScrollAnchor(repeated, 0),
      ], 0.9)!.offset;
      expect(early, lessThan(source.length * 0.3));
      expect(late, greaterThan(source.length * 0.7));
    });

    test('긴 단서가 맞는 쪽을 짧은 오탐보다 우선한다', () {
      final m = locateInSource(source, const [
        ScrollAnchor('문단XYZ 없는 글자', 0),
        ScrollAnchor('문단 41 의 본문 내용입니다.', 30),
      ], 0.0);
      expect(source.substring(m!.offset), startsWith('문단 41 의'));
      expect(m.dy, 30);
    });

    test('단서가 없으면 null', () {
      expect(locateInSource(source, const [], 0.5), isNull);
      expect(
        locateInSource(source, const [ScrollAnchor('전혀없는말', 0)], 0.5),
        isNull,
      );
    });
  });

  group('editAnchors (편집 → 보기)', () {
    test('줄 앞의 마크다운 기호와 인라인 서식을 걷어낸다', () {
      final start = source.indexOf('## 섹션 3');
      final anchors = editAnchors(source, start, 600, (o) => 10);
      expect(anchors.first.snippet, '섹션 3');
      expect(anchors.first.dy, 0);
      // 다음 줄들: 문단 31, 문단 32, "- 할 일 33: **중요** …" → "할 일 33:"
      expect(anchors.map((a) => a.snippet), contains('할 일 33:'));
    });

    test('화면 밖 줄은 단서에 넣지 않는다', () {
      final anchors = editAnchors(source, 0, 600, (o) => 9999);
      expect(anchors, hasLength(1));
    });
  });

  testWidgets('보기 화면에서 단서를 뽑아 원문 위치를 찾고, 반대로도 같은 곳을 찾는다', (tester) async {
    final scroll = ScrollController();
    addTearDown(scroll.dispose);
    final areaKey = GlobalKey();
    final bodyKey = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: KeyedSubtree(
            key: areaKey,
            child: SingleChildScrollView(
              controller: scroll,
              padding: const EdgeInsets.all(16),
              child: KeyedSubtree(
                key: bodyKey,
                child: MarkdownBody(data: source),
              ),
            ),
          ),
        ),
      ),
    );

    // 중간쯤으로 스크롤
    scroll.jumpTo(scroll.position.maxScrollExtent * 0.5);
    await tester.pump();

    final area = areaKey.currentContext!.findRenderObject()! as RenderBox;
    final anchors = previewAnchors(area);
    expect(anchors, isNotEmpty);

    // 보기 → 편집: 화면 맨 위 글자가 원문에서 문서 중간쯤에 잡힌다
    final match = locateInSource(source, anchors, 0.5)!;
    expect(match.offset / source.length, inInclusiveRange(0.3, 0.7));

    // 편집 → 보기: 그 원문 위치의 줄을 단서로 다시 보기 화면에서 찾으면
    // 원래 스크롤 위치 근처가 나온다
    final lineStart = source.lastIndexOf('\n', match.offset) + 1;
    final back = editAnchors(source, lineStart, 600, (o) => 0);
    final body = bodyKey.currentContext!.findRenderObject()! as RenderBox;
    final target = locateInPreview(body, back, 0.5)! + 16;
    expect((target - scroll.offset).abs(), lessThan(120));
  });

  testWidgets('SelectionArea 안에서도 문단은 RenderParagraph로 그려진다', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SelectionArea(child: Markdown(data: source)),
        ),
      ),
    );
    final paragraph = tester.renderObject(find.byType(RichText).first);
    expect(paragraph, isA<RenderParagraph>());
    expect((paragraph as RenderParagraph).registrar, isNotNull);
  });
}
