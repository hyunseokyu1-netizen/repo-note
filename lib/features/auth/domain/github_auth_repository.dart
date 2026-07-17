import 'github_user.dart';

/// 인증 추상화. 향후 OAuth 교체를 고려한 인터페이스.
abstract interface class GitHubAuthRepository {
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Future<void> deleteToken();
  Future<GitHubUser> validateToken(String token);
}
