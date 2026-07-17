import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/providers.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../auth/presentation/session_controller.dart';
import 'settings_controller.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  String _version = '';

  AppLocalizations get _l10n => AppLocalizations.of(context);

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (mounted) {
        setState(() => _version = '${info.version}+${info.buildNumber}');
      }
    });
  }

  Future<bool> _hasDirtyDrafts() async {
    final drafts = await ref.read(databaseProvider).dirtyDrafts();
    return drafts.isNotEmpty;
  }

  Future<void> _clearCache() async {
    final vault = ref.read(sessionControllerProvider).value?.vault;
    if (vault == null) return;
    final dirty = await _hasDirtyDrafts();
    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(_l10n.clearCacheTitle),
        content: Text(
          dirty ? _l10n.clearCacheConfirmDirty : _l10n.clearCacheConfirmClean,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(_l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(_l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(databaseProvider).clearSyncedFiles(vault.id);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_l10n.cacheCleared)));
    }
  }

  Future<void> _logout() async {
    final dirty = await _hasDirtyDrafts();
    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(_l10n.logoutTitle),
        content: Text(
          dirty ? _l10n.logoutConfirmDirty : _l10n.logoutConfirmClean,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(_l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(_l10n.logoutTitle),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(sessionControllerProvider.notifier).logout();
    if (mounted) context.go('/setup/token');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = _l10n;
    final session = ref.watch(sessionControllerProvider).value;
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);
    final user = session?.user;
    final vault = session?.vault;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          if (user != null)
            ListTile(
              leading: user.avatarUrl.isEmpty
                  ? const CircleAvatar(child: Icon(Icons.person))
                  : CircleAvatar(backgroundImage: NetworkImage(user.avatarUrl)),
              title: Text(user.login),
              subtitle: Text(l10n.githubAccount),
            ),
          ListTile(
            leading: const Icon(Icons.key_outlined),
            title: Text(l10n.changeToken),
            onTap: () => context.push('/setup/token'),
          ),
          ListTile(
            leading: const Icon(Icons.source_outlined),
            title: Text(l10n.changeVaultTitle),
            subtitle: vault == null
                ? null
                : Text(
                    '${vault.owner}/${vault.repository} · ${vault.branch} · /${vault.rootPath}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
            onTap: () => context.push('/setup/repository'),
          ),
          const Divider(),
          SwitchListTile(
            secondary: const Icon(Icons.sync_outlined),
            title: Text(l10n.autoSync),
            value: settings.autoSyncEnabled,
            onChanged: controller.setAutoSyncEnabled,
          ),
          ListTile(
            enabled: settings.autoSyncEnabled,
            leading: const Icon(Icons.timer_outlined),
            title: Text(l10n.autoSyncDelay),
            subtitle: Text(
              l10n.autoSyncDelayDesc(settings.autoSyncDelaySeconds),
            ),
            trailing: DropdownButton<int>(
              value: settings.autoSyncDelaySeconds,
              items: const [3, 5, 10, 30, 60]
                  .map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Text(l10n.secondsLabel(s)),
                    ),
                  )
                  .toList(),
              onChanged: settings.autoSyncEnabled
                  ? (v) {
                      if (v != null) controller.setAutoSyncDelay(v);
                    }
                  : null,
            ),
          ),
          const Divider(),
          SwitchListTile(
            secondary: const Icon(Icons.visibility_outlined),
            title: Text(l10n.showHiddenFiles),
            subtitle: Text(l10n.showHiddenFilesDesc),
            value: settings.showHidden,
            onChanged: controller.setShowHidden,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.insert_drive_file_outlined),
            title: Text(l10n.showNonMarkdown),
            value: settings.showNonMarkdown,
            onChanged: controller.setShowNonMarkdown,
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: Text(l10n.themeTitle),
            trailing: DropdownButton<ThemeMode>(
              value: settings.themeMode,
              items: [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text(l10n.themeSystem),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(l10n.themeLight),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text(l10n.themeDark),
                ),
              ],
              onChanged: (v) {
                if (v != null) controller.setThemeMode(v);
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.cleaning_services_outlined),
            title: Text(l10n.clearCacheTitle),
            subtitle: Text(l10n.clearCacheDesc),
            onTap: _clearCache,
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              l10n.logoutTitle,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            onTap: _logout,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.appVersion),
            subtitle: Text(_version.isEmpty ? '…' : _version),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
