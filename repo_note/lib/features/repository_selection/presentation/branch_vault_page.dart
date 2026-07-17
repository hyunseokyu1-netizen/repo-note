import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/errors/failure_messages.dart';
import '../../../core/utils/file_name_validator.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../auth/presentation/session_controller.dart';
import '../data/repo_selection_repository.dart';

/// 브랜치 선택 + Vault Root 폴더 선택 화면.
class BranchVaultPage extends ConsumerStatefulWidget {
  const BranchVaultPage({super.key});

  @override
  ConsumerState<BranchVaultPage> createState() => _BranchVaultPageState();
}

class _BranchVaultPageState extends ConsumerState<BranchVaultPage> {
  List<String> _branches = [];
  String? _branch;
  String _currentPath = '';
  List<String> _folders = [];
  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final repo = ref.read(selectedRepositoryProvider);
    if (repo == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final selection = ref.read(repoSelectionRepositoryProvider);
      final branches = await selection.listBranches(repo.owner, repo.name);
      _branches = branches;
      // 기본 브랜치 자동 선택
      _branch = branches.contains(repo.defaultBranch)
          ? repo.defaultBranch
          : (branches.isNotEmpty ? branches.first : null);
      await _loadFolders();
    } on AppFailure catch (e) {
      if (mounted) setState(() => _error = failureMessage(context, e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadFolders() async {
    final repo = ref.read(selectedRepositoryProvider);
    if (repo == null || _branch == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final selection = ref.read(repoSelectionRepositoryProvider);
      final folders = await selection.listFolders(
        repo.owner,
        repo.name,
        _currentPath,
        _branch!,
      );
      setState(
        () => _folders = folders.where((f) => !f.startsWith('.')).toList(),
      );
    } on AppFailure catch (e) {
      if (mounted) setState(() => _error = failureMessage(context, e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _selectVaultRoot() async {
    final repo = ref.read(selectedRepositoryProvider);
    if (repo == null || _branch == null) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(sessionControllerProvider.notifier)
          .setVault(
            owner: repo.owner,
            repository: repo.name,
            repositoryId: repo.id,
            branch: _branch!,
            rootPath: FileNameValidator.normalizePath(_currentPath),
          );
      if (mounted) context.go('/files');
    } on AppFailure catch (e) {
      if (mounted) setState(() => _error = failureMessage(context, e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final repo = ref.watch(selectedRepositoryProvider);
    if (repo == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.selectBranch)),
        body: Center(child: Text(l10n.selectRepoFirst)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(repo.fullName, overflow: TextOverflow.ellipsis),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownMenu<String>(
              label: Text(l10n.branchLabel),
              initialSelection: _branch,
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries: _branches
                  .map((b) => DropdownMenuEntry(value: b, label: b))
                  .toList(),
              onSelected: (value) {
                if (value == null) return;
                setState(() {
                  _branch = value;
                  _currentPath = '';
                });
                _loadFolders();
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.folder_open),
            title: Text(
              l10n.currentLocation(_currentPath),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(l10n.vaultRootHint),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    children: [
                      if (_currentPath.isNotEmpty)
                        ListTile(
                          leading: const Icon(Icons.arrow_upward),
                          title: Text(l10n.goUpFolder),
                          onTap: () {
                            final idx = _currentPath.lastIndexOf('/');
                            setState(
                              () => _currentPath = idx < 0
                                  ? ''
                                  : _currentPath.substring(0, idx),
                            );
                            _loadFolders();
                          },
                        ),
                      for (final folder in _folders)
                        ListTile(
                          leading: const Icon(Icons.folder_outlined),
                          title: Text(folder),
                          onTap: () {
                            setState(
                              () => _currentPath = FileNameValidator.joinPath(
                                _currentPath,
                                folder,
                              ),
                            );
                            _loadFolders();
                          },
                        ),
                      if (_folders.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Center(child: Text(l10n.noSubfolders)),
                        ),
                    ],
                  ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: _saving || _branch == null ? null : _selectVaultRoot,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        _currentPath.isEmpty
                            ? l10n.selectRootAsVault
                            : l10n.selectFolderAsVault(_currentPath),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
