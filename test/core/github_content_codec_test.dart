import 'package:flutter_test/flutter_test.dart';
import 'package:repo_note/core/utils/github_content_codec.dart';

void main() {
  group('GitHubContentCodec', () {
    test('한글을 포함한 인코딩/디코딩 왕복', () {
      const text = '# 제목\n\n한글 메모 내용입니다. [[위키링크]] #태그';
      final encoded = GitHubContentCodec.encode(text);
      expect(GitHubContentCodec.decode(encoded), text);
    });

    test('GitHub 응답처럼 개행이 포함된 base64를 디코딩한다', () {
      const text = 'Hello RepoNote';
      final encoded = GitHubContentCodec.encode(text);
      final withNewlines =
          '${encoded.substring(0, 8)}\n${encoded.substring(8)}\n';
      expect(GitHubContentCodec.decode(withNewlines), text);
    });

    test('빈 내용 처리', () {
      expect(GitHubContentCodec.decode(''), '');
      expect(GitHubContentCodec.decode(GitHubContentCodec.encode('')), '');
    });
  });
}
