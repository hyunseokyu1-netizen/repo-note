import 'package:flutter_test/flutter_test.dart';
import 'package:repo_note/core/utils/file_name_validator.dart';

void main() {
  group('FileNameValidator.validate', () {
    test('빈 파일명은 거부한다', () {
      expect(FileNameValidator.validate(''), isNotNull);
      expect(FileNameValidator.validate('   '), isNotNull);
    });

    test('슬래시가 포함된 파일명은 거부한다', () {
      expect(FileNameValidator.validate('notes/idea'), isNotNull);
    });

    test('상대경로 공격(..)을 거부한다', () {
      expect(FileNameValidator.validate('..'), isNotNull);
      expect(FileNameValidator.validate('a..b'), isNotNull);
    });

    test('위험한 특수문자를 거부한다', () {
      expect(FileNameValidator.validate('a:b'), isNotNull);
      expect(FileNameValidator.validate('a*b'), isNotNull);
      expect(FileNameValidator.validate('a?b'), isNotNull);
      expect(FileNameValidator.validate('a|b'), isNotNull);
    });

    test('정상 파일명은 통과한다', () {
      expect(FileNameValidator.validate('아이디어 노트'), isNull);
      expect(FileNameValidator.validate('idea-2026.md'), isNull);
    });
  });

  group('FileNameValidator.ensureMarkdownExtension', () {
    test('.md가 없으면 추가한다', () {
      expect(FileNameValidator.ensureMarkdownExtension('idea'), 'idea.md');
    });

    test('이미 .md면 그대로 둔다', () {
      expect(FileNameValidator.ensureMarkdownExtension('idea.md'), 'idea.md');
      expect(FileNameValidator.ensureMarkdownExtension('idea.MD'), 'idea.MD');
    });
  });

  group('FileNameValidator 경로 처리', () {
    test('경로 정규화', () {
      expect(FileNameValidator.normalizePath('/a//b/'), 'a/b');
      expect(FileNameValidator.normalizePath(''), '');
    });

    test('경로 결합', () {
      expect(FileNameValidator.joinPath('notes', 'idea.md'), 'notes/idea.md');
      expect(FileNameValidator.joinPath('', 'idea.md'), 'idea.md');
    });
  });
}
