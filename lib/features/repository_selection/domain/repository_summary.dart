/// 도메인 모델: 저장소 요약 정보.
class RepositorySummary {
  const RepositorySummary({
    required this.id,
    required this.name,
    required this.owner,
    required this.fullName,
    required this.isPrivate,
    required this.defaultBranch,
  });

  final int id;
  final String name;
  final String owner;
  final String fullName;
  final bool isPrivate;
  final String defaultBranch;
}
