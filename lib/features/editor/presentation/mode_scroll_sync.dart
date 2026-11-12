import 'package:flutter/rendering.dart';

/// 보기↔편집 전환 시 "지금 읽던 곳"을 반대 모드에서 찾기 위한 단서.
///
/// 두 모드는 같은 글을 다르게 그리므로(마크다운 기호 유무, 글자 크기) 스크롤
/// 값을 그대로 옮길 수 없다. 대신 화면 맨 위 근처의 글자 조각을 단서로 삼아
/// 반대 모드에서 같은 글자를 찾는다.
class ScrollAnchor {
  const ScrollAnchor(this.snippet, this.dy);

  /// 화면에 보이던 글자 조각.
  final String snippet;

  /// 그 조각이 화면(뷰포트) 맨 위에서 떨어져 있던 거리(px).
  final double dy;
}

/// 단서를 찾았을 때의 결과: 반대 모드 텍스트에서의 위치와 맞춰야 할 화면 거리.
class AnchorMatch {
  const AnchorMatch(this.offset, this.dy);

  final int offset;
  final double dy;
}

const _maxAnchors = 6;
const _snippetLength = 40;
const _prefixLengths = [40, 24, 12, 6, 3];

/// [haystack]에서 [needle]이 나오는 곳 중 [expected]에 가장 가까운 위치.
int? _closestOccurrence(String haystack, String needle, double expected) {
  int? best;
  var from = 0;
  while (true) {
    final i = haystack.indexOf(needle, from);
    if (i < 0) break;
    if (best == null || (i - expected).abs() < (best - expected).abs()) {
      best = i;
    }
    from = i + 1;
  }
  return best;
}

/// 찾아볼 (단서, 검색어) 순서. 서식 경계에서 글자가 달라질 수 있어 긴 앞부분
/// 부터 점점 짧게 시도하되, 짧은 조각의 오탐을 줄이려고 길이를 우선한다.
Iterable<(ScrollAnchor, String)> _attempts(List<ScrollAnchor> anchors) sync* {
  final tried = <String>{};
  for (final length in _prefixLengths) {
    for (final anchor in anchors) {
      final s = anchor.snippet;
      final needle = s.length <= length ? s : s.substring(0, length);
      if (needle.trim().length < 2) continue;
      if (tried.add('${anchor.dy}:$needle')) yield (anchor, needle);
    }
  }
}

String _clip(String text) {
  var s = text.trimLeft();
  final cut = s.indexOf(RegExp('[\n￼]'));
  if (cut >= 0) s = s.substring(0, cut);
  if (s.length > _snippetLength) s = s.substring(0, _snippetLength);
  return s.trimRight();
}

// ---------- 보기 → 편집 ----------

/// 보기 화면([viewport]) 맨 위 근처에 보이는 글자 조각들을 위에서부터 모은다.
List<ScrollAnchor> previewAnchors(RenderBox viewport) {
  final viewTop = viewport.localToGlobal(Offset.zero).dy;
  final viewBottom = viewTop + viewport.size.height;
  final visible = <(double, RenderParagraph)>[];

  void visit(RenderObject node) {
    if (node is RenderParagraph && node.hasSize && node.attached) {
      final top = node.localToGlobal(Offset.zero).dy;
      if (top + node.size.height > viewTop && top < viewBottom) {
        visible.add((top, node));
      }
    }
    node.visitChildren(visit);
  }

  visit(viewport);
  visible.sort((a, b) => a.$1.compareTo(b.$1));

  final anchors = <ScrollAnchor>[];
  for (final (top, paragraph) in visible) {
    if (anchors.length >= _maxAnchors) break;
    final text = paragraph.text.toPlainText(includeSemanticsLabels: false);
    final String snippet;
    final double dy;
    if (top < viewTop) {
      // 문단 중간이 화면 맨 위에 걸쳐 있다: 그 줄의 글자부터.
      final position = paragraph.getPositionForOffset(
        Offset(0, viewTop - top + 1),
      );
      snippet = _clip(text.substring(position.offset.clamp(0, text.length)));
      dy = 0;
    } else {
      snippet = _clip(text);
      dy = top - viewTop;
    }
    if (snippet.length >= 2) anchors.add(ScrollAnchor(snippet, dy));
  }
  return anchors;
}

/// 보기 화면의 단서를 원문([source])에서 찾는다. [fraction]은 스크롤 진행률.
AnchorMatch? locateInSource(
  String source,
  List<ScrollAnchor> anchors,
  double fraction,
) {
  final expected = fraction * source.length;
  for (final (anchor, needle) in _attempts(anchors)) {
    final offset = _closestOccurrence(source, needle, expected);
    if (offset != null) return AnchorMatch(offset, anchor.dy);
  }
  return null;
}

// ---------- 편집 → 보기 ----------

final _blockMarker = RegExp(
  r'^\s*(?:#{1,6}\s+|>\s*|[-*+]\s+\[[ xX]\]\s+|[-*+]\s+|\d+[.)]\s+)*',
);
final _inlineMarkup = RegExp(r'[*_`\[\]~|<>!\\]');

/// 원문 한 줄에서 화면에 그대로 보일 앞부분만 남긴다.
String _renderedPrefix(String line, {required bool fromLineStart}) {
  var s = line;
  if (fromLineStart) s = s.replaceFirst(_blockMarker, '');
  s = s.trimLeft();
  final cut = s.indexOf(_inlineMarkup);
  if (cut >= 0) s = s.substring(0, cut);
  if (s.length > _snippetLength) s = s.substring(0, _snippetLength);
  return s.trimRight();
}

/// 편집 화면 맨 위([topOffset]: 원문 위치)부터 보이는 줄들을 단서로 만든다.
///
/// [lineTop]은 원문 위치의 화면 y좌표(뷰포트 기준)를 돌려준다.
List<ScrollAnchor> editAnchors(
  String source,
  int topOffset,
  double viewportHeight,
  double Function(int offset) lineTop,
) {
  final anchors = <ScrollAnchor>[];
  var start = topOffset.clamp(0, source.length);
  var first = true;
  while (start < source.length && anchors.length < _maxAnchors) {
    var end = source.indexOf('\n', start);
    if (end < 0) end = source.length;
    final lineStart = start == 0 ? 0 : source.lastIndexOf('\n', start - 1) + 1;
    final atLineStart = start == lineStart;
    final dy = first ? 0.0 : lineTop(start);
    if (dy > viewportHeight) break;
    final snippet = _renderedPrefix(
      source.substring(start, end),
      fromLineStart: atLineStart,
    );
    if (snippet.length >= 2) anchors.add(ScrollAnchor(snippet, dy));
    start = end + 1;
    first = false;
  }
  return anchors;
}

/// 편집 화면의 단서를 렌더링된 보기 화면에서 찾는다.
///
/// [content]는 문서 전체가 배치된 렌더 박스(MarkdownBody). 돌려주는 값은
/// [content] 기준 y좌표에서 화면 거리를 뺀 "스크롤해야 할 위치"다.
double? locateInPreview(
  RenderBox content,
  List<ScrollAnchor> anchors,
  double fraction,
) {
  final paragraphs = <(double, RenderParagraph, String)>[];

  void visit(RenderObject node) {
    if (node is RenderParagraph && node.hasSize) {
      final top = MatrixUtils.transformPoint(
        node.getTransformTo(content),
        Offset.zero,
      ).dy;
      paragraphs.add((
        top,
        node,
        node.text.toPlainText(includeSemanticsLabels: false),
      ));
    }
    node.visitChildren(visit);
  }

  visit(content);
  if (paragraphs.isEmpty) return null;
  final expectedY = fraction * content.size.height;

  for (final (anchor, needle) in _attempts(anchors)) {
    double? bestY;
    for (final (top, paragraph, text) in paragraphs) {
      var from = 0;
      while (true) {
        final index = text.indexOf(needle, from);
        if (index < 0) break;
        final boxes = paragraph.getBoxesForSelection(
          TextSelection(baseOffset: index, extentOffset: index + 1),
        );
        final y = top + (boxes.isEmpty ? 0 : boxes.first.top);
        if (bestY == null ||
            (y - expectedY).abs() < (bestY - expectedY).abs()) {
          bestY = y;
        }
        from = index + 1;
      }
    }
    if (bestY != null) return bestY - anchor.dy;
  }
  return null;
}
