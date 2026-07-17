import 'package:dio/dio.dart';

/// 앱 내부 오류 타입. 사용자에게 보여줄 문구는 UI 계층에서
/// `failureMessage()`로 현재 언어에 맞게 변환한다.
/// Token, 문서 본문, Authorization Header는 절대 포함하지 않는다.
sealed class AppFailure implements Exception {
  const AppFailure({this.code});

  /// 내부 분류용 코드 (로그·재시도 정책용).
  final String? code;

  @override
  String toString() => '$runtimeType($code)';

  /// DioException을 AppFailure로 변환한다. 응답 본문/헤더는 노출하지 않는다.
  static AppFailure fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.connectionError:
        return const NetworkFailure();
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode ?? 0;
        final remaining = e.response?.headers.value('x-ratelimit-remaining');
        if (status == 401) return const UnauthorizedFailure();
        if (status == 403) {
          if (remaining == '0') {
            final reset = e.response?.headers.value('x-ratelimit-reset');
            return RateLimitFailure(
              resetEpochSeconds: int.tryParse(reset ?? ''),
            );
          }
          return const PermissionDeniedFailure();
        }
        if (status == 404) return const NotFoundFailure();
        if (status == 409 || status == 422) return const ConflictFailure();
        return UnknownFailure(code: 'http_$status');
      case DioExceptionType.cancel:
        return const UnknownFailure(code: 'cancelled');
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return const NetworkFailure();
    }
  }
}

class NetworkFailure extends AppFailure {
  const NetworkFailure() : super(code: 'network');
}

class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure() : super(code: 'unauthorized');
}

class PermissionDeniedFailure extends AppFailure {
  const PermissionDeniedFailure() : super(code: 'permission_denied');
}

class RateLimitFailure extends AppFailure {
  const RateLimitFailure({this.resetEpochSeconds}) : super(code: 'rate_limit');

  final int? resetEpochSeconds;

  DateTime? get resetAt => resetEpochSeconds == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch(resetEpochSeconds! * 1000);
}

class NotFoundFailure extends AppFailure {
  const NotFoundFailure() : super(code: 'not_found');
}

class ConflictFailure extends AppFailure {
  const ConflictFailure() : super(code: 'conflict');
}

class LocalStorageFailure extends AppFailure {
  const LocalStorageFailure() : super(code: 'local_storage');
}

/// 파일명/경로 검증 오류 종류.
enum ValidationErrorKind {
  emptyName,
  slashInName,
  dotsInName,
  specialChars,
  duplicateName,
  renamePartialFailure,
}

class ValidationFailure extends AppFailure {
  const ValidationFailure(this.kind) : super(code: 'validation');

  final ValidationErrorKind kind;
}

class UnknownFailure extends AppFailure {
  const UnknownFailure({String? code}) : super(code: code ?? 'unknown');
}
