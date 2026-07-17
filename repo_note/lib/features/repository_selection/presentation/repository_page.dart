import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/errors/failure_messages.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../data/repo_selection_repository.dart';
import '../domain/repository_summary.dart';

class RepositoryPage extends ConsumerStatefulWidget {
  const RepositoryPage({super.key});

  @override
  ConsumerState<RepositoryPage> createState() => _RepositoryPageState();
}

class _RepositoryPageState extends ConsumerState<RepositoryPage> {
  final _repos = <RepositorySummary>[];
  final _scrollController = ScrollController();
  String _query = '';
  int _page = 1;
  bool _loading = false;
  bool _hasMore = true;
  String? _error;
  bool _authError = false;

  @override
  void initState() {
    super.initState();
    _loadMore();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 200) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMore() async {
    if (_loading || !_hasMore) return;
    setState(() {
      _loading = true;
      _error = null;
      _authError = false;
    });
    try {
      final repo = ref.read(repoSelectionRepositoryProvider);
      final items = await repo.listRepositories(page: _page);
      setState(() {
        _repos.addAll(items);
        _hasMore = items.length >= 50;
        _page++;
      });
    } on AppFailure catch (e) {
      if (mounted) {
        setState(() {
          _error = failureMessage(context, e);
          // 토큰이 무효화된 경우 재등록 경로를 제공한다.
          _authError = e is UnauthorizedFailure || e is PermissionDeniedFailure;
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _repos.clear();
      _page = 1;
      _hasMore = true;
    });
    await _loadMore();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filtered = _query.isEmpty
        ? _repos
        : _repos
              .where(
                (r) => r.fullName.toLowerCase().contains(_query.toLowerCase()),
              )
              .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.selectRepository),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refresh),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: l10n.searchRepositoryHint,
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  if (_authError) ...[
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      icon: const Icon(Icons.key_outlined),
                      label: Text(l10n.reRegisterToken),
                      onPressed: () => context.go('/setup/token'),
                    ),
                  ],
                ],
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: filtered.length + (_loading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= filtered.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final repo = filtered[index];
                  return ListTile(
                    leading: Icon(
                      repo.isPrivate ? Icons.lock_outline : Icons.public,
                    ),
                    title: Text(repo.name),
                    subtitle: Text(
                      repo.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      repo.isPrivate ? l10n.privateLabel : l10n.publicLabel,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    onTap: () {
                      ref
                          .read(selectedRepositoryProvider.notifier)
                          .select(repo);
                      context.push('/setup/branch');
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
