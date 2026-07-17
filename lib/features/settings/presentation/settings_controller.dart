import 'package:flutter/material.dart' show Locale, ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/storage/app_database.dart';

class AppSettingsState {
  const AppSettingsState({
    this.autoSyncEnabled = true,
    this.autoSyncDelaySeconds = 5,
    this.showHidden = false,
    this.showNonMarkdown = false,
    this.themeMode = ThemeMode.system,
    this.localeCode = '',
  });

  final bool autoSyncEnabled;
  final int autoSyncDelaySeconds;
  final bool showHidden;
  final bool showNonMarkdown;
  final ThemeMode themeMode;

  /// 앱 언어 코드. 빈 문자열이면 시스템 언어를 따른다.
  final String localeCode;

  /// MaterialApp에 전달할 Locale. null이면 시스템 언어.
  Locale? get locale => localeCode.isEmpty ? null : Locale(localeCode);

  AppSettingsState copyWith({
    bool? autoSyncEnabled,
    int? autoSyncDelaySeconds,
    bool? showHidden,
    bool? showNonMarkdown,
    ThemeMode? themeMode,
    String? localeCode,
  }) => AppSettingsState(
    autoSyncEnabled: autoSyncEnabled ?? this.autoSyncEnabled,
    autoSyncDelaySeconds: autoSyncDelaySeconds ?? this.autoSyncDelaySeconds,
    showHidden: showHidden ?? this.showHidden,
    showNonMarkdown: showNonMarkdown ?? this.showNonMarkdown,
    themeMode: themeMode ?? this.themeMode,
    localeCode: localeCode ?? this.localeCode,
  );
}

class SettingsController extends Notifier<AppSettingsState> {
  static const _kAutoSync = 'auto_sync_enabled';
  static const _kAutoSyncDelay = 'auto_sync_delay_seconds';
  static const _kShowHidden = 'show_hidden';
  static const _kShowNonMd = 'show_non_md';
  static const _kThemeMode = 'theme_mode';
  static const _kLocale = 'app_locale';

  AppDatabase get _db => ref.read(databaseProvider);

  @override
  AppSettingsState build() {
    _load();
    return const AppSettingsState();
  }

  Future<void> _load() async {
    final autoSync = await _db.getSetting(_kAutoSync);
    final delay = await _db.getSetting(_kAutoSyncDelay);
    final showHidden = await _db.getSetting(_kShowHidden);
    final showNonMd = await _db.getSetting(_kShowNonMd);
    final theme = await _db.getSetting(_kThemeMode);
    final locale = await _db.getSetting(_kLocale);
    state = AppSettingsState(
      autoSyncEnabled: autoSync != '0',
      autoSyncDelaySeconds: int.tryParse(delay ?? '') ?? 5,
      showHidden: showHidden == '1',
      showNonMarkdown: showNonMd == '1',
      themeMode: switch (theme) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      },
      localeCode: switch (locale) {
        'ko' || 'en' => locale!,
        _ => '',
      },
    );
  }

  Future<void> setAutoSyncEnabled(bool enabled) async {
    state = state.copyWith(autoSyncEnabled: enabled);
    await _db.setSetting(_kAutoSync, enabled ? '1' : '0');
  }

  Future<void> setAutoSyncDelay(int seconds) async {
    state = state.copyWith(autoSyncDelaySeconds: seconds);
    await _db.setSetting(_kAutoSyncDelay, seconds.toString());
  }

  Future<void> setShowHidden(bool show) async {
    state = state.copyWith(showHidden: show);
    await _db.setSetting(_kShowHidden, show ? '1' : '0');
  }

  Future<void> setShowNonMarkdown(bool show) async {
    state = state.copyWith(showNonMarkdown: show);
    await _db.setSetting(_kShowNonMd, show ? '1' : '0');
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _db.setSetting(_kThemeMode, switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    });
  }

  /// 앱 언어 변경. [code]는 'ko', 'en' 또는 ''(시스템).
  Future<void> setLocaleCode(String code) async {
    state = state.copyWith(localeCode: code);
    await _db.setSetting(_kLocale, code);
  }
}

final settingsControllerProvider =
    NotifierProvider<SettingsController, AppSettingsState>(
      SettingsController.new,
    );
