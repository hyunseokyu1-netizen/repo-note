import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/github_api_client.dart';
import '../../../core/providers.dart';
import '../domain/repository_summary.dart';

/// 저장소/브랜치/폴더 선택 화면용 Repository.
class RepoSelectionRepository {
  RepoSelectionRepository(this._api);

  final GitHubApiClient _api;

  Future<List<RepositorySummary>> listRepositories({int page = 1}) async {
    final dtos = await _api.listRepositories(page: page);
    return dtos
        .map(
          (d) => RepositorySummary(
            id: d.id,
            name: d.name,
            owner: d.ownerLogin,
            fullName: d.fullName,
            isPrivate: d.isPrivate,
            defaultBranch: d.defaultBranch,
          ),
        )
        .toList();
  }

  Future<List<String>> listBranches(
    String owner,
    String repo, {
    int page = 1,
  }) async {
    final dtos = await _api.listBranches(owner, repo, page: page);
    return dtos.map((d) => d.name).toList();
  }

  /// 지정 경로의 하위 폴더 이름 목록.
  Future<List<String>> listFolders(
    String owner,
    String repo,
    String path,
    String ref,
  ) async {
    final entries = await _api.listContents(owner, repo, path, ref);
    return entries.where((e) => e.isDir).map((e) => e.name).toList()..sort();
  }
}

final repoSelectionRepositoryProvider = Provider<RepoSelectionRepository>(
  (ref) => RepoSelectionRepository(ref.watch(gitHubApiClientProvider)),
);

/// 설정 플로우 중 선택된 저장소 (브랜치 화면에서 사용).
class SelectedRepositoryNotifier extends Notifier<RepositorySummary?> {
  @override
  RepositorySummary? build() => null;

  void select(RepositorySummary repo) => state = repo;
}

final selectedRepositoryProvider =
    NotifierProvider<SelectedRepositoryNotifier, RepositorySummary?>(
      SelectedRepositoryNotifier.new,
    );
