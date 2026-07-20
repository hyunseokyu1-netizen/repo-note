import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;

/// Obsidian `[[위키링크]]` / `![[임베드]]` 문법을 인식하는 인라인 파서.
/// `[[대상|표시명]]` 별칭 문법도 지원한다. 원문은 변경하지 않는다.
class WikiLinkSyntax extends md.InlineSyntax {
  WikiLinkSyntax() : super(r'!?\[\[([^\[\]]+)\]\]');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final inner = match[1]!.trim();
    final parts = inner.split('|');
    final target = parts.first.trim();
    final display = (parts.length > 1 ? parts[1] : parts.first).trim();

    final element = md.Element.text('wikilink', display);
    element.attributes['target'] = target;
    element.attributes['embed'] = match[0]!.startsWith('!') ? '1' : '0';
    parser.addNode(element);
    return true;
  }
}

/// `[[위키링크]]`를 탭 가능한 칩으로 렌더링한다.
class WikiLinkBuilder extends MarkdownElementBuilder {
  WikiLinkBuilder({required this.colorScheme, required this.onTap});

  final ColorScheme colorScheme;
  final void Function(String target) onTap;

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final target = element.attributes['target'] ?? element.textContent;
    final isEmbed = element.attributes['embed'] == '1';
    final fontSize = preferredStyle?.fontSize ?? 16;

    return GestureDetector(
      onTap: () => onTap(target),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 1),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isEmbed ? Icons.attachment_outlined : Icons.description_outlined,
              size: fontSize * 0.85,
              color: colorScheme.onSecondaryContainer,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                element.textContent,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: (preferredStyle ?? const TextStyle()).copyWith(
                  color: colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
