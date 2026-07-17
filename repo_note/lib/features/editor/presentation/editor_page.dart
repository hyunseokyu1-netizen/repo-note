import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/errors/failure_messages.dart';
import '../../../core/providers.dart';
import '../../../core/storage/app_database.dart';
import '../../../core/storage/sync_enums.dart';
import '../../../core/utils/debouncer.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../auth/presentation/session_controller.dart';
import '../../file_browser/data/notes_repository.dart';
import '../../settings/presentation/settings_controller.dart';
import '../../sync/data/sync_coordinator.dart';
import '../../sync/domain/sync_result.dart';

/// 편집 화면 저장 상태.
enum EditorStatus {
  saved,
  savingLocal,
  pendingSync,
  syncing,
  offline,
  conflict,
  syncFailed,
}

class EditorPage extends ConsumerStatefulWidget {
  const EditorPage({super.key, required this.fileId});

  final String fileId;

  @override
  ConsumerState<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends ConsumerState<EditorPage>
    with WidgetsBindingObserver {
  final _textController = TextEditingController();
  final _saveDebouncer = Debouncer(const Duration(milliseconds: 600));
  Debouncer? _syncDebouncer;

  NoteFile? _file;
  EditorStatus _status = EditorStatus.saved;
  bool _preview = false;
  bool _loading = true;
  String? _loadError;
  String _lastSavedText = '';

  VaultConfig? get _vault => ref.read(sessionControllerProvider).value?.vault;

  AppLocalizations get _l10n => AppLocalizations.of(context);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(_open);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _saveDebouncer.cancel();
    _syncDebouncer?.cancel();
    // 마지막 변경사항을 유실 없이 저장 (fire-and-forget)
    _persistIfChanged();
    _textController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 백그라운드 전환 시 로컬 저장을 즉시 수행한다.
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _saveDebouncer.cancel();
      _persistIfChanged();
    }
  }

  Future<void> _open() async {
    final vault = _vault;
    if (vault == null) return;
    try {
      final note = await ref
          .read(notesRepositoryProvider)
          .openFile(vault, widget.fileId);
      if (!mounted) return;
      setState(() {
        _file = note.file;
        _textController.text = note.content;
        _lastSavedText = note.content;
        _loading = false;
        _status = switch (note.status) {
          SyncStatus.conflict => EditorStatus.conflict,
          SyncStatus.failed => EditorStatus.syncFailed,
          SyncStatus.pendingUpload || SyncStatus.localOnly =>
            note.fromLocal ? EditorStatus.pendingSync : EditorStatus.saved,
          _ => EditorStatus.saved,
        };
      });
    } on AppFailure catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _loadError = failureMessage(context, e);
        });
      }
    }
  }

  void _onChanged(String text) {
    if (_status != EditorStatus.conflict) {
      setState(() => _status = EditorStatus.savingLocal);
    }
    _saveDebouncer.run(_persistIfChanged);
  }

  Future<void> _persistIfChanged() async {
    final vault = _vault;
    final text = _textController.text;
    if (vault == null || text == _lastSavedText) {
      if (mounted && _status == EditorStatus.savingLocal) {
        setState(() => _status = EditorStatus.saved);
      }
      return;
    }
    try {
      await ref
          .read(notesRepositoryProvider)
          .saveDraft(vault, widget.fileId, text);
      _lastSavedText = text;
      if (mounted) {
        setState(() {
          if (_status != EditorStatus.conflict) {
            _status = EditorStatus.pendingSync;
          }
        });
        _scheduleAutoSync();
      }
    } on AppFailure {
      if (mounted) setState(() => _status = EditorStatus.syncFailed);
    }
  }

  void _scheduleAutoSync() {
    final settings = ref.read(settingsControllerProvider);
    if (!settings.autoSyncEnabled) return;
    _syncDebouncer ??= Debouncer(
      Duration(seconds: settings.autoSyncDelaySeconds),
    );
    _syncDebouncer!.run(() => _sync(manual: false));
  }

  Future<void> _sync({required bool manual}) async {
    final vault = _vault;
    if (vault == null || _status == EditorStatus.conflict) return;
    final online = ref.read(connectivityProvider).value ?? true;
    if (!online) {
      if (mounted) setState(() => _status = EditorStatus.offline);
      return;
    }
    // 현재 편집 내용을 먼저 로컬 저장
    _saveDebouncer.cancel();
    await _persistIfChanged();

    if (mounted) setState(() => _status = EditorStatus.syncing);
    final result = await ref
        .read(syncCoordinatorProvider)
        .syncFile(vault, widget.fileId);
    if (!mounted) return;
    setState(() {
      _status = switch (result) {
        SyncResult.uploaded || SyncResult.upToDate => EditorStatus.saved,
        SyncResult.conflict => EditorStatus.conflict,
        SyncResult.failed => EditorStatus.syncFailed,
        SyncResult.deleted || SyncResult.skipped => _status,
      };
    });
    if (result == SyncResult.conflict && manual) {
      _openConflict();
    }
  }

  Future<void> _openConflict() async {
    await context.push('/conflict?fileId=${widget.fileId}');
    if (mounted) {
      setState(() => _loading = true);
      await _open();
    }
  }

  String _statusLabel(EditorStatus status) => switch (status) {
    EditorStatus.saved => _l10n.statusSaved,
    EditorStatus.savingLocal => _l10n.statusSavingLocal,
    EditorStatus.pendingSync => _l10n.statusPendingSync,
    EditorStatus.syncing => _l10n.statusSyncing,
    EditorStatus.offline => _l10n.statusOffline,
    EditorStatus.conflict => _l10n.statusConflict,
    EditorStatus.syncFailed => _l10n.statusSyncFailed,
  };

  Color _statusColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return switch (_status) {
      EditorStatus.conflict || EditorStatus.syncFailed => scheme.error,
      EditorStatus.offline => scheme.tertiary,
      _ => scheme.onSurfaceVariant,
    };
  }

  @override
  Widget build(BuildContext context) {
    final file = _file;
    final dirPath = () {
      if (file == null) return '';
      final idx = file.path.lastIndexOf('/');
      return idx < 0 ? '/' : '/${file.path.substring(0, idx)}';
    }();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              file?.name ?? '…',
              style: const TextStyle(fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '$dirPath · ${_statusLabel(_status)}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: _statusColor(context)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: _preview ? _l10n.editTooltip : _l10n.previewTooltip,
            icon: Icon(
              _preview ? Icons.edit_outlined : Icons.visibility_outlined,
            ),
            onPressed: () => setState(() => _preview = !_preview),
          ),
          IconButton(
            tooltip: _l10n.syncNow,
            icon: const Icon(Icons.sync),
            onPressed: () => _sync(manual: true),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'keyboard':
                  FocusScope.of(context).unfocus();
                case 'conflict':
                  _openConflict();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'keyboard',
                child: Text(_l10n.closeKeyboard),
              ),
              if (_status == EditorStatus.conflict)
                PopupMenuItem(
                  value: 'conflict',
                  child: Text(_l10n.resolveConflict),
                ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _loadError != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(_loadError!),
                ),
              )
            : Column(
                children: [
                  if (_status == EditorStatus.conflict)
                    MaterialBanner(
                      content: Text(_l10n.conflictBanner),
                      leading: const Icon(Icons.warning_amber),
                      actions: [
                        TextButton(
                          onPressed: _openConflict,
                          child: Text(_l10n.resolveConflict),
                        ),
                      ],
                    ),
                  Expanded(
                    child: _preview
                        ? Markdown(
                            data: _textController.text,
                            padding: const EdgeInsets.all(16),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: TextField(
                              controller: _textController,
                              onChanged: _onChanged,
                              maxLines: null,
                              expands: true,
                              textAlignVertical: TextAlignVertical.top,
                              keyboardType: TextInputType.multiline,
                              style: const TextStyle(fontSize: 16, height: 1.5),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: _l10n.memoHint,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
