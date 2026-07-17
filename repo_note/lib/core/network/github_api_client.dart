import 'package:dio/dio.dart';

import '../errors/app_failure.dart';
import 'github_dtos.dart';

/// 마지막 응답의 Rate Limit 정보.
class RateLimitInfo {
  int? remaining;
  DateTime? resetAt;
}

/// GitHub REST API 클라이언트.
/// Authorization Header는 Interceptor에서 주입되며 로그에 출력하지 않는다.
class GitHubApiClient {
  GitHubApiClient({required Future<String?> Function() tokenProvider, Dio? dio})
    : _dio = dio ?? Dio() {
    _dio.options = _dio.options.copyWith(
      baseUrl: 'https://api.github.com',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/vnd.github+json',
        'X-GitHub-Api-Version': '2022-11-28',
      },
    );
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 요청에 이미 Authorization이 지정된 경우(예: 새 토큰 검증)에는
          // 저장된 토큰으로 덮어쓰지 않는다.
          if (!options.headers.containsKey('Authorization')) {
            final token = await tokenProvider();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          _collectRateLimit(response.headers);
          handler.next(response);
        },
        onError: (error, handler) {
          final headers = error.response?.headers;
          if (headers != null) _collectRateLimit(headers);
          handler.next(error);
        },
      ),
    );
  }

  final Dio _dio;
  final RateLimitInfo rateLimit = RateLimitInfo();

  void _collectRateLimit(Headers headers) {
    final remaining = int.tryParse(
      headers.value('x-ratelimit-remaining') ?? '',
    );
    final reset = int.tryParse(headers.value('x-ratelimit-reset') ?? '');
    if (remaining != null) rateLimit.remaining = remaining;
    if (reset != null) {
      rateLimit.resetAt = DateTime.fromMillisecondsSinceEpoch(reset * 1000);
    }
  }

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on DioException catch (e) {
      throw AppFailure.fromDio(e);
    }
  }

  /// 현재 사용자 조회. [tokenOverride]가 있으면 저장 전 검증용으로 사용한다.
  Future<GitHubUserDto> getCurrentUser({String? tokenOverride}) =>
      _guard(() async {
        final res = await _dio.get<Map<String, dynamic>>(
          '/user',
          options: tokenOverride == null
              ? null
              : Options(headers: {'Authorization': 'Bearer $tokenOverride'}),
        );
        return GitHubUserDto.fromJson(res.data!);
      });

  Future<List<RepositoryDto>> listRepositories({
    int page = 1,
    int perPage = 50,
  }) => _guard(() async {
    final res = await _dio.get<List<dynamic>>(
      '/user/repos',
      queryParameters: {
        'per_page': perPage,
        'page': page,
        'sort': 'pushed',
        'direction': 'desc',
      },
    );
    return res.data!
        .map((e) => RepositoryDto.fromJson(e as Map<String, dynamic>))
        .toList();
  });

  Future<List<BranchDto>> listBranches(
    String owner,
    String repo, {
    int page = 1,
    int perPage = 100,
  }) => _guard(() async {
    final res = await _dio.get<List<dynamic>>(
      '/repos/$owner/$repo/branches',
      queryParameters: {'per_page': perPage, 'page': page},
    );
    return res.data!
        .map((e) => BranchDto.fromJson(e as Map<String, dynamic>))
        .toList();
  });

  /// 디렉터리 콘텐츠 목록 조회. path가 비어 있으면 루트.
  Future<List<ContentEntryDto>> listContents(
    String owner,
    String repo,
    String path,
    String ref,
  ) => _guard(() async {
    final res = await _dio.get<dynamic>(
      _contentsUrl(owner, repo, path),
      queryParameters: {'ref': ref},
    );
    final data = res.data;
    if (data is List) {
      return data
          .map((e) => ContentEntryDto.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    // 파일 경로를 디렉터리처럼 조회한 경우
    return [ContentEntryDto.fromJson(data as Map<String, dynamic>)];
  });

  Future<FileContentDto> getFile(
    String owner,
    String repo,
    String path,
    String ref,
  ) => _guard(() async {
    final res = await _dio.get<Map<String, dynamic>>(
      _contentsUrl(owner, repo, path),
      queryParameters: {'ref': ref},
    );
    return FileContentDto.fromJson(res.data!);
  });

  /// 파일의 현재 서버 SHA만 조회. 파일이 없으면 null.
  Future<String?> getFileSha(
    String owner,
    String repo,
    String path,
    String ref,
  ) async {
    try {
      final res = await _guard(
        () => _dio.get<Map<String, dynamic>>(
          _contentsUrl(owner, repo, path),
          queryParameters: {'ref': ref},
        ),
      );
      return res.data!['sha'] as String?;
    } on NotFoundFailure {
      return null;
    }
  }

  /// 파일 생성 또는 수정. 새 파일은 [sha]를 보내지 않는다.
  Future<PutFileResultDto> putFile({
    required String owner,
    required String repo,
    required String path,
    required String message,
    required String contentBase64,
    required String branch,
    String? sha,
  }) => _guard(() async {
    final res = await _dio.put<Map<String, dynamic>>(
      _contentsUrl(owner, repo, path),
      data: {
        'message': message,
        'content': contentBase64,
        'branch': branch,
        'sha': ?sha,
      },
    );
    return PutFileResultDto.fromJson(res.data!);
  });

  Future<void> deleteFile({
    required String owner,
    required String repo,
    required String path,
    required String message,
    required String sha,
    required String branch,
  }) => _guard(() async {
    await _dio.delete<Map<String, dynamic>>(
      _contentsUrl(owner, repo, path),
      data: {'message': message, 'sha': sha, 'branch': branch},
    );
  });

  String _contentsUrl(String owner, String repo, String path) {
    final encoded = path.isEmpty
        ? ''
        : path.split('/').map(Uri.encodeComponent).join('/');
    return '/repos/$owner/$repo/contents/$encoded';
  }
}
