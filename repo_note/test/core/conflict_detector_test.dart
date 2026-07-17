import 'package:flutter_test/flutter_test.dart';
import 'package:repo_note/core/utils/conflict_detector.dart';

void main() {
  group('ConflictDetector', () {
    test('SHA가 같으면 충돌이 아니다', () {
      expect(
        ConflictDetector.isConflict(baseSha: 'abc123', serverSha: 'abc123'),
        isFalse,
      );
    });

    test('SHA가 다르면 충돌이다', () {
      expect(
        ConflictDetector.isConflict(baseSha: 'abc123', serverSha: 'def456'),
        isTrue,
      );
    });

    test('새 파일인데 서버에 이미 존재하면 충돌이다', () {
      expect(
        ConflictDetector.isConflict(baseSha: null, serverSha: 'abc123'),
        isTrue,
      );
    });

    test('새 파일이고 서버에도 없으면 충돌이 아니다', () {
      expect(
        ConflictDetector.isConflict(baseSha: null, serverSha: null),
        isFalse,
      );
    });

    test('서버에서 파일이 삭제되었으면 충돌이다', () {
      expect(
        ConflictDetector.isConflict(baseSha: 'abc123', serverSha: null),
        isTrue,
      );
    });
  });
}
