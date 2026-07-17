import 'dart:convert';

import '../core/network/github_api_client.dart';
import '../core/network/github_dtos.dart';

/// 스크린샷 전용 가짜 GitHub API. 실제 네트워크 요청을 보내지 않는다.
class FakeGitHubApiClient extends GitHubApiClient {
  FakeGitHubApiClient({required this.tree, required this.contents})
    : super(tokenProvider: () async => 'demo');

  /// 폴더 경로 → 항목 목록. 폴더는 'dir:이름', 파일은 '이름.md'.
  final Map<String, List<String>> tree;

  /// 파일 경로 → Markdown 본문.
  final Map<String, String> contents;

  String _shaFor(String path) =>
      path.hashCode.toRadixString(16).padLeft(8, '0');

  @override
  Future<GitHubUserDto> getCurrentUser({String? tokenOverride}) async =>
      const GitHubUserDto(id: 1, login: 'demo-user', avatarUrl: '');

  @override
  Future<List<RepositoryDto>> listRepositories({
    int page = 1,
    int perPage = 50,
  }) async => page > 1
      ? []
      : [
          const RepositoryDto(
            id: 1,
            name: 'obsidian-notes',
            ownerLogin: 'demo-user',
            fullName: 'demo-user/obsidian-notes',
            isPrivate: true,
            defaultBranch: 'main',
          ),
        ];

  @override
  Future<List<BranchDto>> listBranches(
    String owner,
    String repo, {
    int page = 1,
    int perPage = 100,
  }) async => page > 1 ? [] : [const BranchDto(name: 'main')];

  @override
  Future<List<ContentEntryDto>> listContents(
    String owner,
    String repo,
    String path,
    String ref,
  ) async {
    final items = tree[path] ?? [];
    return items.map((item) {
      final isDir = item.startsWith('dir:');
      final name = isDir ? item.substring(4) : item;
      final fullPath = path.isEmpty ? name : '$path/$name';
      return ContentEntryDto(
        type: isDir ? 'dir' : 'file',
        name: name,
        path: fullPath,
        sha: _shaFor(fullPath),
        size: 100,
      );
    }).toList();
  }

  @override
  Future<FileContentDto> getFile(
    String owner,
    String repo,
    String path,
    String ref,
  ) async {
    final name = path.contains('/') ? path.split('/').last : path;
    return FileContentDto(
      name: name,
      path: path,
      sha: _shaFor(path),
      contentBase64: base64.encode(utf8.encode(contents[path] ?? '# $name\n')),
      encoding: 'base64',
    );
  }

  @override
  Future<String?> getFileSha(
    String owner,
    String repo,
    String path,
    String ref,
  ) async => _shaFor(path);

  @override
  Future<PutFileResultDto> putFile({
    required String owner,
    required String repo,
    required String path,
    required String message,
    required String contentBase64,
    required String branch,
    String? sha,
  }) async => PutFileResultDto(contentSha: _shaFor(path), commitSha: 'commit');

  @override
  Future<void> deleteFile({
    required String owner,
    required String repo,
    required String path,
    required String message,
    required String sha,
    required String branch,
  }) async {}
}
