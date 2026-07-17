import 'dart:convert';

/// GitHub Contents API의 Base64 본문 인코딩/디코딩.
/// 응답 base64에는 개행이 포함될 수 있어 제거 후 디코딩한다.
class GitHubContentCodec {
  const GitHubContentCodec._();

  static String decode(String base64Content) {
    final normalized = base64Content.replaceAll('\n', '').replaceAll('\r', '');
    if (normalized.isEmpty) return '';
    return utf8.decode(base64.decode(normalized));
  }

  static String encode(String text) => base64.encode(utf8.encode(text));
}
