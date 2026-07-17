/// 도메인 모델: GitHub 사용자.
class GitHubUser {
  const GitHubUser({
    required this.id,
    required this.login,
    required this.avatarUrl,
  });

  final int id;
  final String login;
  final String avatarUrl;
}
