import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// 일치 항목 강조색 (라이트/다크 모두에서 읽히는 반투명 색).
const Color kFindMatchColor = Color(0x59FFC107);
const Color kFindCurrentColor = Color(0xA6FF6D00);

/// [text]에서 [query]가 나오는 모든 범위를 대소문자 구분 없이 찾는다.
List<TextRange> findMatches(String text, String query) {
  if (query.isEmpty || text.isEmpty) return const [];
  final pattern = RegExp(RegExp.escape(query), caseSensitive: false);
  return [
    for (final m in pattern.allMatches(text))
      TextRange(start: m.start, end: m.end),
  ];
}

/// 화면 맨 위([topOffset]) 이후 처음 나오는 항목의 인덱스. 없으면 첫 항목.
int firstMatchFrom<T>(List<T> items, bool Function(T) isAtOrAfterTop) {
  if (items.isEmpty) return -1;
  final i = items.indexWhere(isAtOrAfterTop);
  return i < 0 ? 0 : i;
}

/// 편집 모드에서 찾기 결과를 배경색으로 강조하는 텍스트 컨트롤러.
class FindHighlightController extends TextEditingController {
  List<TextRange> _matches = const [];
  int _current = -1;

  List<TextRange> get matches => _matches;

  void setHighlights(List<TextRange> matches, int current) {
    _matches = matches;
    _current = current;
    notifyListeners();
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    // 한글 조합 중에는 기본 구현(조합 밑줄)을 그대로 쓴다.
    final composing = withComposing && value.isComposingRangeValid;
    if (_matches.isEmpty || composing) {
      return super.buildTextSpan(
        context: context,
        style: style,
        withComposing: withComposing,
      );
    }
    final text = this.text;
    final children = <TextSpan>[];
    var cursor = 0;
    for (var i = 0; i < _matches.length; i++) {
      final m = _matches[i];
      if (m.start < cursor || m.end > text.length) continue;
      if (m.start > cursor) {
        children.add(TextSpan(text: text.substring(cursor, m.start)));
      }
      children.add(
        TextSpan(
          text: text.substring(m.start, m.end),
          style: TextStyle(
            backgroundColor: i == _current
                ? kFindCurrentColor
                : kFindMatchColor,
          ),
        ),
      );
      cursor = m.end;
    }
    if (cursor < text.length) {
      children.add(TextSpan(text: text.substring(cursor)));
    }
    return TextSpan(style: style, children: children);
  }
}

/// [offset]이 화면에 충분히 보이지 않으면 위에서 30% 지점에 오도록 스크롤한다.
///
/// [top]/[bottom]은 스크롤 콘텐츠 기준 좌표.
void revealInScrollView(
  ScrollController controller,
  double top,
  double bottom,
) {
  if (!controller.hasClients) return;
  final position = controller.position;
  final viewport = position.viewportDimension;
  final visibleTop = position.pixels + 8;
  final visibleBottom = position.pixels + viewport - 24;
  if (top >= visibleTop && bottom <= visibleBottom) return;
  final target = (top - viewport * 0.3).clamp(
    position.minScrollExtent,
    position.maxScrollExtent,
  );
  controller.jumpTo(target);
}

/// 보기(미리보기) 모드용 찾기 레이어.
///
/// 렌더링된 마크다운의 실제 글자를 대상으로 찾기 때문에, 화면에 보이는 것과
/// 개수·위치가 정확히 일치한다. 일치 항목 위에 강조색을 덧칠하고, 현재 항목이
/// 화면 밖이면 스크롤한다.
///
/// [child]는 지연 로딩 없이 전체가 배치되는 위젯이어야 한다 (MarkdownBody).
class PreviewFindLayer extends StatefulWidget {
  const PreviewFindLayer({
    super.key,
    required this.query,
    required this.data,
    required this.index,
    required this.scrollController,
    required this.topInset,
    required this.onResults,
    required this.child,
  });

  final String query;

  /// 원문. 바뀌면 다시 찾는다.
  final String data;

  /// 현재 선택된 항목 (부모가 관리).
  final int index;

  final ScrollController scrollController;

  /// 스크롤 콘텐츠 맨 위에서 이 레이어까지의 여백.
  final double topInset;

  /// 찾기 결과가 갱신될 때 (개수, 선택할 인덱스)를 알린다.
  final void Function(int count, int index) onResults;

  final Widget child;

  @override
  State<PreviewFindLayer> createState() => _PreviewFindLayerState();
}

class _PreviewFindLayerState extends State<PreviewFindLayer> {
  /// 항목별 사각형 목록 (줄바꿈되면 여러 개). 이 레이어 기준 좌표.
  List<List<Rect>> _rects = const [];
  String? _searchedQuery;
  bool _scheduled = false;

  @override
  void initState() {
    super.initState();
    _scheduleSearch();
  }

  @override
  void didUpdateWidget(PreviewFindLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query || oldWidget.data != widget.data) {
      _scheduleSearch();
    } else if (oldWidget.index != widget.index) {
      _reveal(widget.index);
    }
  }

  void _scheduleSearch() {
    if (_scheduled) return;
    _scheduled = true;
    // 배치가 끝난 뒤에야 글자 위치를 알 수 있다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      if (mounted) _search();
    });
  }

  void _search() {
    final root = context.findRenderObject();
    if (root is! RenderBox || !root.hasSize) return;
    final query = widget.query;
    final rects = <List<Rect>>[];

    if (query.isNotEmpty) {
      void visit(RenderObject node) {
        if (node is RenderParagraph && node.hasSize) {
          final text = node.text.toPlainText(includeSemanticsLabels: false);
          final matches = findMatches(text, query);
          if (matches.isNotEmpty) {
            final toRoot = node.getTransformTo(root);
            for (final m in matches) {
              final boxes = node.getBoxesForSelection(
                TextSelection(baseOffset: m.start, extentOffset: m.end),
              );
              if (boxes.isEmpty) continue;
              rects.add([
                for (final b in boxes)
                  MatrixUtils.transformRect(toRoot, b.toRect()),
              ]);
            }
          }
        }
        node.visitChildren(visit);
      }

      visit(root);
    }

    // 검색어가 바뀌었으면 지금 보고 있는 위치부터, 아니면 기존 선택을 유지한다.
    final int index;
    if (rects.isEmpty) {
      index = -1;
    } else if (_searchedQuery != query) {
      final top = widget.scrollController.hasClients
          ? widget.scrollController.position.pixels - widget.topInset
          : 0.0;
      index = firstMatchFrom(rects, (r) => r.first.top >= top);
    } else {
      index = widget.index.clamp(0, rects.length - 1);
    }
    _searchedQuery = query;

    setState(() => _rects = rects);
    widget.onResults(rects.length, index);
    _reveal(index);
  }

  void _reveal(int index) {
    if (index < 0 || index >= _rects.length) return;
    final rect = _rects[index].first;
    revealInScrollView(
      widget.scrollController,
      rect.top + widget.topInset,
      rect.bottom + widget.topInset,
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<SizeChangedLayoutNotification>(
      // 이미지 로딩·화면 회전 등으로 배치가 바뀌면 위치를 다시 계산한다.
      onNotification: (_) {
        _scheduleSearch();
        return true;
      },
      child: CustomPaint(
        foregroundPainter: _HighlightPainter(_rects, widget.index),
        child: SizeChangedLayoutNotifier(child: widget.child),
      ),
    );
  }
}

class _HighlightPainter extends CustomPainter {
  _HighlightPainter(this.rects, this.current);

  final List<List<Rect>> rects;
  final int current;

  @override
  void paint(Canvas canvas, Size size) {
    final normal = Paint()..color = kFindMatchColor;
    final active = Paint()..color = kFindCurrentColor;
    for (var i = 0; i < rects.length; i++) {
      final paint = i == current ? active : normal;
      for (final rect in rects[i]) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect.inflate(1), const Radius.circular(2)),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_HighlightPainter oldDelegate) =>
      oldDelegate.rects != rects || oldDelegate.current != current;
}
