import '../errors/app_failure.dart';

/// 파일명 및 경로 검증 유틸.
class FileNameValidator {
  const FileNameValidator._();

  /// Windows/macOS에서 문제가 될 수 있는 특수문자.
  static final RegExp _riskyChars = RegExp(r'[\\:*?"<>|]');

  /// 파일명을 검증하고 문제가 있으면 오류 종류를 반환한다.
  /// 문제가 없으면 null을 반환한다.
  static ValidationErrorKind? validate(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return ValidationErrorKind.emptyName;
    if (trimmed.contains('/')) return ValidationErrorKind.slashInName;
    if (trimmed == '.' || trimmed == '..' || trimmed.contains('..')) {
      return ValidationErrorKind.dotsInName;
    }
    if (_riskyChars.hasMatch(trimmed)) {
      return ValidationErrorKind.specialChars;
    }
    return null;
  }

  /// `.md` 확장자를 자동으로 보정한다.
  static String ensureMarkdownExtension(String name) {
    final trimmed = name.trim();
    if (trimmed.toLowerCase().endsWith('.md')) return trimmed;
    return '$trimmed.md';
  }

  /// 경로 정규화: 중복 슬래시 제거, 앞뒤 슬래시 제거.
  static String normalizePath(String path) {
    final parts = path.split('/').where((p) => p.isNotEmpty).toList();
    return parts.join('/');
  }

  /// 두 경로를 결합한다.
  static String joinPath(String dir, String name) {
    final d = normalizePath(dir);
    return d.isEmpty ? name : '$d/$name';
  }
}
