import '../../../core/network/github_api_client.dart';
import '../../../core/storage/secure_token_storage.dart';
import '../domain/github_auth_repository.dart';
import '../domain/github_user.dart';

class GitHubAuthRepositoryImpl implements GitHubAuthRepository {
  GitHubAuthRepositoryImpl({
    required this._tokenStorage,
    required this._apiClient,
  });

  final SecureTokenStorage _tokenStorage;
  final GitHubApiClient _apiClient;

  @override
  Future<String?> getToken() => _tokenStorage.readToken();

  @override
  Future<void> saveToken(String token) => _tokenStorage.writeToken(token);

  @override
  Future<void> deleteToken() => _tokenStorage.deleteToken();

  @override
  Future<GitHubUser> validateToken(String token) async {
    final dto = await _apiClient.getCurrentUser(tokenOverride: token);
    return GitHubUser(id: dto.id, login: dto.login, avatarUrl: dto.avatarUrl);
  }
}
