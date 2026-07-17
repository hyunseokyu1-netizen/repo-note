/// GitHub REST API 응답 DTO. 화면에서 직접 사용하지 않는다.
library;

class GitHubUserDto {
  const GitHubUserDto({
    required this.id,
    required this.login,
    required this.avatarUrl,
  });

  factory GitHubUserDto.fromJson(Map<String, dynamic> json) => GitHubUserDto(
    id: json['id'] as int,
    login: json['login'] as String,
    avatarUrl: json['avatar_url'] as String? ?? '',
  );

  final int id;
  final String login;
  final String avatarUrl;
}

class RepositoryDto {
  const RepositoryDto({
    required this.id,
    required this.name,
    required this.ownerLogin,
    required this.fullName,
    required this.isPrivate,
    required this.defaultBranch,
    this.pushedAt,
  });

  factory RepositoryDto.fromJson(Map<String, dynamic> json) => RepositoryDto(
    id: json['id'] as int,
    name: json['name'] as String,
    ownerLogin: (json['owner'] as Map<String, dynamic>)['login'] as String,
    fullName: json['full_name'] as String,
    isPrivate: json['private'] as bool? ?? false,
    defaultBranch: json['default_branch'] as String? ?? 'main',
    pushedAt: DateTime.tryParse(json['pushed_at'] as String? ?? ''),
  );

  final int id;
  final String name;
  final String ownerLogin;
  final String fullName;
  final bool isPrivate;
  final String defaultBranch;
  final DateTime? pushedAt;
}

class BranchDto {
  const BranchDto({required this.name});

  factory BranchDto.fromJson(Map<String, dynamic> json) =>
      BranchDto(name: json['name'] as String);

  final String name;
}

class ContentEntryDto {
  const ContentEntryDto({
    required this.type,
    required this.name,
    required this.path,
    required this.sha,
    required this.size,
  });

  factory ContentEntryDto.fromJson(Map<String, dynamic> json) =>
      ContentEntryDto(
        type: json['type'] as String,
        name: json['name'] as String,
        path: json['path'] as String,
        sha: json['sha'] as String,
        size: json['size'] as int? ?? 0,
      );

  final String type; // 'file' | 'dir' | 'symlink' | 'submodule'
  final String name;
  final String path;
  final String sha;
  final int size;

  bool get isDir => type == 'dir';
  bool get isFile => type == 'file';
}

class FileContentDto {
  const FileContentDto({
    required this.name,
    required this.path,
    required this.sha,
    required this.contentBase64,
    required this.encoding,
  });

  factory FileContentDto.fromJson(Map<String, dynamic> json) => FileContentDto(
    name: json['name'] as String,
    path: json['path'] as String,
    sha: json['sha'] as String,
    contentBase64: json['content'] as String? ?? '',
    encoding: json['encoding'] as String? ?? 'base64',
  );

  final String name;
  final String path;
  final String sha;
  final String contentBase64;
  final String encoding;
}

class PutFileResultDto {
  const PutFileResultDto({required this.contentSha, required this.commitSha});

  factory PutFileResultDto.fromJson(Map<String, dynamic> json) {
    final content = json['content'] as Map<String, dynamic>?;
    final commit = json['commit'] as Map<String, dynamic>?;
    return PutFileResultDto(
      contentSha: content?['sha'] as String? ?? '',
      commitSha: commit?['sha'] as String? ?? '',
    );
  }

  final String contentSha;
  final String commitSha;
}
