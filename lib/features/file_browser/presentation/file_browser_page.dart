import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/errors/failure_messages.dart';
import '../../../core/providers.dart';
import '../../../core/storage/app_database.dart';
import '../../../core/storage/sync_enums.dart';
import '../../../core/utils/file_name_validator.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../auth/presentation/session_controller.dart';
import '../../settings/presentation/settings_controller.dart';
import '../../sync/data/sync_coordinator.dart';
import '../../sync/domain/sync_result.dart';
import '../data/notes_repository.dart';
import '../domain/browser_entry.dart';

/// 트리 뷰의 한 행 (평탄화된 항목).
class _TreeRow {
  const _TreeRow({required this.entry, required this.depth});

  final BrowserEntry entry;
  final int depth;
}

/// Obsidian 스타일 접기/펼치기 트리 탐색 화면.
class FileBrowserPage extends ConsumerStatefulWidget {
  const FileBrowserPage({super.key});

  @override
  ConsumerState<FileBrowserPage> createState() => _FileBrowserPageState();
}

class _FileBrowserPageState extends ConsumerState<FileBrowserPage> {
  /// 폴더 경로 → 자식 항목 캐시.
  final Map<String, List<BrowserEntry>> _children = {};
  final Set<String> _expanded = {};
  final Set<String> _loadingDirs = {};
  bool _offline = false;
  String? _error;

  VaultConfig? get _vault => ref.read(sessionControllerProvider).value?.vault;

  String get _rootPath => _vault?.rootPath ?? '';

  AppLocalizations get _l10n => AppLocalizations.of(context);

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await _loadDir(_rootPath);
      await _autoSyncPending();
    });
  }

  // ---------- 데이터 로드 ----------

  Future<void> _loadDir(String dirPath) async {
    final vault = _vault;
    if (vault == null) return;
    final repo = ref.read(notesRepositoryProvider);

    setState(() {
      _loadingDirs.add(dirPath);
      _error = null;
    });

    // 로컬 캐시를 먼저 렌더링
    if (_children[dirPath] == null) {
      final local = await repo.listLocal(vault, dirPath);
      if (mounted && local.isNotEmpty) {
        setState(() => _children[dirPath] = local);
      }
    }

    try {
      final remote = await repo.listRemote(vault, dirPath);
      if (mounted) {
        setState(() {
          _children[dirPath] = remote;
          _offline = false;
        });
      }
    } on NetworkFailure {
      if (mounted) {
        setState(() {
          _children[dirPath] ??= [];
          _offline = true;
        });
      }
    } on AppFailure catch (e) {
      if (mounted) {
        setState(() {
          _children[dirPath] ??= [];
          _error = failureMessage(context, e);
        });
      }
    } finally {
      if (mounted) setState(() => _loadingDirs.remove(dirPath));
    }
  }

  /// 루트와 펼쳐진 모든 폴더를 다시 로드한다.
  Future<void> _refreshAll() async {
    await _loadDir(_rootPath);
    for (final dir in _expanded.toList()) {
      await _loadDir(dir);
    }
  }

  Future<void> _autoSyncPending() async {
    final vault = _vault;
    if (vault == null) return;
    final settings = ref.read(settingsControllerProvider);
    if (!settings.autoSyncEnabled) return;
    final summary = await ref.read(syncCoordinatorProvider).syncAll(vault);
    if (summary.uploaded > 0 || summary.deleted > 0 || summary.conflicts > 0) {
      await _refreshAll();
    }
  }

  String _summaryText(SyncSummary summary) {
    if (!summary.hasChanges) return _l10n.syncNoChanges;
    final parts = <String>[
      if (summary.uploaded > 0) _l10n.syncUploadedCount(summary.uploaded),
      if (summary.deleted > 0) _l10n.syncDeletedCount(summary.deleted),
      if (summary.conflicts > 0) _l10n.syncConflictCount(summary.conflicts),
      if (summary.failed > 0) _l10n.syncFailedCount(summary.failed),
    ];
    return parts.isEmpty ? _l10n.syncNoChanges : parts.join(', ');
  }

  // ---------- 트리 구성 ----------

  List<BrowserEntry> _sorted(List<BrowserEntry> entries) {
    final settings = ref.read(settingsControllerProvider);
    final filtered = entries.where((e) {
      if (!settings.showHidden && e.name.startsWith('.')) return false;
      if (!e.isDir &&
          !settings.showNonMarkdown &&
          !e.name.toLowerCase().endsWith('.md')) {
        return false;
      }
      return true;
    }).toList();
    filtered.sort((a, b) {
      if (a.isDir != b.isDir) return a.isDir ? -1 : 1;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return filtered;
  }

  List<_TreeRow> _flatten() {
    final rows = <_TreeRow>[];
    void walk(String dirPath, int depth) {
      final children = _children[dirPath];
      if (children == null) return;
      for (final entry in _sorted(children)) {
        rows.add(_TreeRow(entry: entry, depth: depth));
        if (entry.isDir && _expanded.contains(entry.fullPath)) {
          walk(entry.fullPath, depth + 1);
        }
      }
    }

    walk(_rootPath, 0);
    return rows;
  }

  // ---------- 동작 ----------

  Future<void> _toggleFolder(BrowserEntry entry) async {
    final path = entry.fullPath;
    if (_expanded.contains(path)) {
      setState(() => _expanded.remove(path));
      return;
    }
    setState(() => _expanded.add(path));
    if (_children[path] == null) {
      await _loadDir(path);
    }
  }

  Future<void> _openFile(BrowserEntry entry) async {
    if (entry.fileId == null) {
      _showSnack(_l10n.markdownOnly);
      return;
    }
    if (entry.hasConflict) {
      await context.push('/conflict?fileId=${entry.fileId}');
    } else {
      await context.push('/editor?fileId=${entry.fileId}');
    }
    await _refreshAll();
  }

  Future<void> _manualSync() async {
    final vault = _vault;
    if (vault == null) return;
    _showSnack(_l10n.syncStarting);
    final summary = await ref
        .read(syncCoordinatorProvider)
        .syncAll(vault, manual: true);
    if (!mounted) return;
    _showSnack(_summaryText(summary));
    await _refreshAll();
  }

  Future<void> _createMemo(String dirPath) async {
    final vault = _vault;
    if (vault == null) return;
    final name = await _promptText(
      title: _l10n.newMemo,
      hint: _l10n.newMemoFileNameHint,
    );
    if (name == null || name.trim().isEmpty) return;
    try {
      final file = await ref
          .read(notesRepositoryProvider)
          .createLocalFile(vault, dirPath, name);
      if (dirPath != _rootPath) _expanded.add(dirPath);
      if (!mounted) return;
      await context.push('/editor?fileId=${file.id}');
      await _refreshAll();
    } on AppFailure catch (e) {
      if (mounted) _showSnack(failureMessage(context, e));
    }
  }

  Future<void> _createFolder(String parentPath) async {
    final folder = await _promptText(
      title: _l10n.newFolder,
      hint: _l10n.folderNameHint,
    );
    if (folder == null || folder.trim().isEmpty) return;
    final error = FileNameValidator.validate(folder);
    if (error != null) {
      if (mounted) _showSnack(validationMessage(context, error));
      return;
    }
    // GitHub은 빈 폴더를 지원하지 않으므로 폴더 안에 첫 메모를 만든다.
    await _createMemo(FileNameValidator.joinPath(parentPath, folder.trim()));
  }

  Future<void> _rename(BrowserEntry entry) async {
    final vault = _vault;
    if (vault == null || entry.fileId == null) return;
    final newName = await _promptText(
      title: _l10n.renameTitle,
      hint: _l10n.newFileNameHint,
      initial: entry.name,
    );
    if (newName == null || newName.trim().isEmpty) return;
    try {
      await ref
          .read(notesRepositoryProvider)
          .rename(vault, entry.fileId!, newName);
      _showSnack(_l10n.renameDone);
    } on AppFailure catch (e) {
      if (mounted) _showSnack(failureMessage(context, e));
    }
    await _refreshAll();
  }

  Future<void> _delete(BrowserEntry entry) async {
    if (entry.fileId == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_l10n.deleteFileTitle),
        content: Text(_l10n.deleteFileConfirm(entry.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(_l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(notesRepositoryProvider).markDelete(entry.fileId!);
    await _autoSyncPending();
    await _refreshAll();
  }

  Future<void> _showEntryActions(BrowserEntry entry) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                entry.name,
                style: Theme.of(sheetContext).textTheme.titleSmall,
              ),
            ),
            if (entry.isDir) ...[
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: Text(_l10n.newMemoInFolder),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _createMemo(entry.fullPath);
                },
              ),
              ListTile(
                leading: const Icon(Icons.create_new_folder_outlined),
                title: Text(_l10n.newFolderInFolder),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _createFolder(entry.fullPath);
                },
              ),
            ] else if (entry.fileId != null) ...[
              ListTile(
                leading: const Icon(Icons.drive_file_rename_outline),
                title: Text(_l10n.renameTitle),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _rename(entry);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: Text(_l10n.delete),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _delete(entry);
                },
              ),
            ],
            ListTile(
              leading: const Icon(Icons.copy_outlined),
              title: Text(_l10n.copyPath),
              subtitle: Text(
                entry.fullPath,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: entry.fullPath));
                if (sheetContext.mounted) Navigator.pop(sheetContext);
                _showSnack(_l10n.pathCopied);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _promptText({
    required String title,
    required String hint,
    String? initial,
  }) {
    final controller = TextEditingController(text: initial ?? '');
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: hint),
          onSubmitted: (v) => Navigator.pop(dialogContext, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(_l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text),
            child: Text(_l10n.ok),
          ),
        ],
      ),
    );
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  // ---------- 행 렌더링 ----------

  Widget? _statusBadge(BrowserEntry entry) {
    final scheme = Theme.of(context).colorScheme;
    return switch (entry.syncStatus) {
      SyncStatus.conflict => Icon(
        Icons.warning_amber,
        size: 18,
        color: scheme.error,
      ),
      SyncStatus.localOnly || SyncStatus.pendingUpload => Icon(
        Icons.cloud_upload_outlined,
        size: 16,
        color: scheme.onSurfaceVariant,
      ),
      SyncStatus.uploading => Icon(
        Icons.sync,
        size: 16,
        color: scheme.onSurfaceVariant,
      ),
      SyncStatus.pendingDelete => Icon(
        Icons.delete_sweep_outlined,
        size: 16,
        color: scheme.error,
      ),
      SyncStatus.failed => Icon(
        Icons.cloud_off_outlined,
        size: 16,
        color: scheme.error,
      ),
      _ => null,
    };
  }

  Widget _buildRow(_TreeRow row) {
    final entry = row.entry;
    final scheme = Theme.of(context).colorScheme;
    final indent = 20.0 * row.depth;
    final isExpanded = _expanded.contains(entry.fullPath);
    final isLoadingDir = _loadingDirs.contains(entry.fullPath);

    if (entry.isDir) {
      return InkWell(
        onTap: () => _toggleFolder(entry),
        onLongPress: () => _showEntryActions(entry),
        child: SizedBox(
          height: 44,
          child: Row(
            children: [
              SizedBox(width: 12 + indent),
              isLoadingDir
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.chevron_right,
                      size: 20,
                      color: scheme.onSurfaceVariant,
                    ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  entry.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
      );
    }

    final badge = _statusBadge(entry);
    return InkWell(
      onTap: () => _openFile(entry),
      onLongPress: () => _showEntryActions(entry),
      child: SizedBox(
        height: 44,
        child: Row(
          children: [
            SizedBox(width: 12 + indent),
            // 세로 가이드 라인
            Container(width: 1.5, height: 44, color: scheme.outlineVariant),
            const SizedBox(width: 22),
            Expanded(
              child: Text(
                entry.name.toLowerCase().endsWith('.md')
                    ? entry.name.substring(0, entry.name.length - 3)
                    : entry.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  color: entry.hasConflict ? scheme.error : null,
                ),
              ),
            ),
            if (badge != null) ...[badge, const SizedBox(width: 4)],
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionControllerProvider).value;
    final vault = session?.vault;
    ref.watch(settingsControllerProvider);

    // 연결 복구 시 자동 동기화
    ref.listen(connectivityProvider, (previous, next) {
      final wasOffline = previous?.value == false;
      if (wasOffline && next.value == true) {
        _autoSyncPending();
        _refreshAll();
      }
    });

    if (vault == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final rows = _flatten();
    final rootLoading = _loadingDirs.contains(_rootPath);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(vault.repository, style: const TextStyle(fontSize: 17)),
            Text(
              vault.rootPath.isEmpty ? '/' : '/${vault.rootPath}',
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              await context.push('/search');
              await _refreshAll();
            },
          ),
          IconButton(icon: const Icon(Icons.sync), onPressed: _manualSync),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () async {
              await context.push('/settings');
              if (mounted) {
                setState(() {
                  _children.clear();
                  _expanded.clear();
                });
                await _loadDir(_rootPath);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_offline)
            MaterialBanner(
              content: Text(_l10n.offlineBanner),
              leading: const Icon(Icons.wifi_off),
              actions: [
                TextButton(onPressed: _refreshAll, child: Text(_l10n.retry)),
              ],
            ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          if (rootLoading) const LinearProgressIndicator(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshAll,
              child: rows.isEmpty && !rootLoading
                  ? ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(48),
                          child: Center(child: Text(_l10n.emptyFilesMessage)),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 4, bottom: 96),
                      itemCount: rows.length,
                      itemBuilder: (context, index) => _buildRow(rows[index]),
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'new_folder',
            tooltip: _l10n.newFolder,
            onPressed: () => _createFolder(_rootPath),
            child: const Icon(Icons.create_new_folder_outlined),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'new_memo',
            onPressed: () => _createMemo(_rootPath),
            icon: const Icon(Icons.edit_outlined),
            label: Text(_l10n.newMemo),
          ),
        ],
      ),
    );
  }
}
