import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/errors/failure_messages.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../auth/presentation/session_controller.dart';
import '../data/conflict_resolver.dart';

class ConflictPage extends ConsumerStatefulWidget {
  const ConflictPage({super.key, required this.fileId});

  final String fileId;

  @override
  ConsumerState<ConflictPage> createState() => _ConflictPageState();
}

class _ConflictPageState extends ConsumerState<ConflictPage> {
  ConflictDetail? _detail;
  bool _loading = true;
  bool _working = false;
  String? _error;

  AppLocalizations get _l10n => AppLocalizations.of(context);

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load() async {
    try {
      final detail = await ref
          .read(conflictResolverProvider)
          .loadDetail(widget.fileId);
      if (mounted) {
        setState(() {
          _detail = detail;
          _loading = false;
        });
      }
    } on AppFailure catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = failureMessage(context, e);
        });
      }
    }
  }

  Future<void> _run(
    Future<void> Function() action,
    String confirmMessage,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(_l10n.confirmTitle),
        content: Text(confirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(_l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(_l10n.proceed),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _working = true);
    try {
      await action();
      if (mounted) context.pop();
    } on AppFailure catch (e) {
      if (mounted) {
        setState(() {
          _working = false;
          _error = failureMessage(context, e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = _l10n;
    final vault = ref.watch(sessionControllerProvider).value?.vault;
    final detail = _detail;
    final fmt = DateFormat('yyyy-MM-dd HH:mm:ss');

    return Scaffold(
      appBar: AppBar(title: Text(l10n.resolveConflict)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : detail == null
          ? Center(child: Text(_error ?? l10n.conflictNotFound))
          : Column(
              children: [
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(
                          tabs: [
                            Tab(
                              text: l10n.serverVersionTab(
                                fmt.format(detail.detectedAt),
                              ),
                            ),
                            Tab(
                              text: l10n.localVersionTab(
                                detail.localUpdatedAt == null
                                    ? '-'
                                    : fmt.format(detail.localUpdatedAt!),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              _ContentView(
                                content: detail.serverContent.isEmpty
                                    ? l10n.serverContentMissing
                                    : detail.serverContent,
                              ),
                              _ContentView(content: detail.localContent),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_working)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: LinearProgressIndicator(),
                          ),
                        OutlinedButton(
                          onPressed: _working || vault == null
                              ? null
                              : () => _run(
                                  () => ref
                                      .read(conflictResolverProvider)
                                      .useServerVersion(vault, widget.fileId),
                                  l10n.useServerConfirm,
                                ),
                          child: Text(l10n.useServerVersion),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: _working || vault == null
                              ? null
                              : () => _run(
                                  () => ref
                                      .read(conflictResolverProvider)
                                      .overwriteWithMine(vault, widget.fileId),
                                  l10n.useMineConfirm,
                                ),
                          child: Text(l10n.overwriteWithMine),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: _working || vault == null
                              ? null
                              : () => _run(
                                  () => ref
                                      .read(conflictResolverProvider)
                                      .createMergedCopy(vault, widget.fileId),
                                  l10n.keepBothConfirm,
                                ),
                          child: Text(l10n.keepBothVersions),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _working ? null : () => context.pop(),
                          child: Text(l10n.resolveLater),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _ContentView extends StatelessWidget {
  const _ContentView({required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: SelectableText(
        content,
        style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
      ),
    );
  }
}
