import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/errors/failure_messages.dart';
import '../../../core/storage/app_database.dart';
import '../../../core/utils/file_name_validator.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../repository_selection/data/repo_selection_repository.dart';

/// 대상 폴더를 선택하는 다이얼로그. 저장소를 실시간으로 탐색한다.
/// 확정하면 선택한 폴더 경로(저장소 루트 기준)를 반환한다.
class FolderPickerDialog extends ConsumerStatefulWidget {
  const FolderPickerDialog({super.key, required this.vault, this.excludePath});

  final VaultConfig vault;

  /// 이동 대상에서 제외할 경로 (자기 자신과 하위 폴더).
  final String? excludePath;

  static Future<String?> show(
    BuildContext context, {
    required VaultConfig vault,
    String? excludePath,
  }) {
    return showDialog<String>(
      context: context,
      builder: (_) =>
          FolderPickerDialog(vault: vault, excludePath: excludePath),
    );
  }

  @override
  ConsumerState<FolderPickerDialog> createState() => _FolderPickerDialogState();
}

class _FolderPickerDialogState extends ConsumerState<FolderPickerDialog> {
  late String _currentPath;
  List<String> _folders = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _currentPath = widget.vault.rootPath;
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = ref.read(repoSelectionRepositoryProvider);
      final folders = await repo.listFolders(
        widget.vault.owner,
        widget.vault.repository,
        _currentPath,
        widget.vault.branch,
      );
      final filtered = folders.where((f) {
        if (f.startsWith('.')) return false;
        final full = FileNameValidator.joinPath(_currentPath, f);
        // 자기 자신·하위 폴더는 대상에서 제외
        final exclude = widget.excludePath;
        if (exclude != null &&
            (full == exclude || full.startsWith('$exclude/'))) {
          return false;
        }
        return true;
      }).toList();
      if (mounted) setState(() => _folders = filtered);
    } on AppFailure catch (e) {
      if (mounted) setState(() => _error = failureMessage(context, e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  bool get _isAtRoot => _currentPath == widget.vault.rootPath;

  void _goUp() {
    if (_isAtRoot) return;
    final idx = _currentPath.lastIndexOf('/');
    setState(() {
      _currentPath = idx < 0 ? '' : _currentPath.substring(0, idx);
      if (_currentPath.length < widget.vault.rootPath.length) {
        _currentPath = widget.vault.rootPath;
      }
    });
    _load();
  }

  void _enter(String folder) {
    setState(
      () => _currentPath = FileNameValidator.joinPath(_currentPath, folder),
    );
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final displayPath = _currentPath.isEmpty ? '/' : '/$_currentPath';

    return AlertDialog(
      title: Text(l10n.folderPickerTitle),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              displayPath,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Divider(),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            SizedBox(
              height: 260,
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      children: [
                        if (!_isAtRoot)
                          ListTile(
                            dense: true,
                            leading: const Icon(Icons.arrow_upward),
                            title: Text(l10n.goUpFolder),
                            onTap: _goUp,
                          ),
                        for (final folder in _folders)
                          ListTile(
                            dense: true,
                            leading: const Icon(Icons.folder_outlined),
                            title: Text(folder),
                            trailing: const Icon(Icons.chevron_right, size: 18),
                            onTap: () => _enter(folder),
                          ),
                        if (_folders.isEmpty && !_isAtRoot)
                          const SizedBox.shrink(),
                      ],
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _loading
              ? null
              : () => Navigator.pop(context, _currentPath),
          child: Text(l10n.moveHere),
        ),
      ],
    );
  }
}
