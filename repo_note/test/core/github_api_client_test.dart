import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repo_note/core/network/github_api_client.dart';

/// 요청 헤더를 기록하고 가짜 응답을 돌려주는 어댑터.
class _CapturingAdapter implements HttpClientAdapter {
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    return ResponseBody.fromString(
      '{"id": 1, "login": "tester", "avatar_url": ""}',
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  group('GitHubApiClient Authorization 헤더', () {
    late _CapturingAdapter adapter;
    late GitHubApiClient client;

    setUp(() {
      adapter = _CapturingAdapter();
      final dio = Dio();
      dio.httpClientAdapter = adapter;
      client = GitHubApiClient(
        tokenProvider: () async => 'stored-old-token',
        dio: dio,
      );
    });

    test('일반 요청은 저장된 토큰을 사용한다', () async {
      await client.getCurrentUser();
      expect(
        adapter.lastRequest!.headers['Authorization'],
        'Bearer stored-old-token',
      );
    });

    test('tokenOverride가 있으면 저장된 토큰으로 덮어쓰지 않는다', () async {
      // 회귀 테스트: 새 토큰 검증 시 옛 토큰이 헤더를 덮어쓰면
      // 폐기된 토큰으로 요청이 나가 401이 발생한다.
      await client.getCurrentUser(tokenOverride: 'brand-new-token');
      expect(
        adapter.lastRequest!.headers['Authorization'],
        'Bearer brand-new-token',
      );
    });

    test('공통 헤더가 설정된다', () async {
      await client.getCurrentUser();
      expect(
        adapter.lastRequest!.headers['Accept'],
        'application/vnd.github+json',
      );
      expect(
        adapter.lastRequest!.headers['X-GitHub-Api-Version'],
        '2022-11-28',
      );
    });
  });
}
