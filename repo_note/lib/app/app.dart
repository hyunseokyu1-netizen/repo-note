import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/settings/presentation/settings_controller.dart';
import '../l10n/gen/app_localizations.dart';
import 'router.dart';
import 'theme.dart';

class RepoNoteApp extends ConsumerWidget {
  const RepoNoteApp({super.key, this.localeOverride});

  /// 스크린샷 등 특수 빌드에서만 사용. null이면 시스템 언어를 따른다.
  final Locale? localeOverride;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(
      settingsControllerProvider.select((s) => s.themeMode),
    );

    return MaterialApp.router(
      title: 'RepoNote',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      // 기본은 시스템(핸드폰) 언어를 따라간다.
      locale: localeOverride,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
