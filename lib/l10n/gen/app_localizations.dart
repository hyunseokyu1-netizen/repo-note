import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'GitHub repository notepad'**
  String get appTagline;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceed;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @confirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmTitle;

  /// No description provided for @githubConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect GitHub'**
  String get githubConnect;

  /// No description provided for @tokenGuideBody.
  ///
  /// In en, this message translates to:
  /// **'We recommend a token that can only access your note repository.\nRequired permissions: Repository contents (Read and write), Metadata (Read-only)'**
  String get tokenGuideBody;

  /// No description provided for @tokenLabel.
  ///
  /// In en, this message translates to:
  /// **'GitHub Token'**
  String get tokenLabel;

  /// No description provided for @tokenEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter a token.'**
  String get tokenEmpty;

  /// No description provided for @verifyConnection.
  ///
  /// In en, this message translates to:
  /// **'Verify connection'**
  String get verifyConnection;

  /// No description provided for @tokenIssueGuide.
  ///
  /// In en, this message translates to:
  /// **'Open GitHub token settings'**
  String get tokenIssueGuide;

  /// No description provided for @tokenGuideDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'How to set token permissions'**
  String get tokenGuideDetailTitle;

  /// No description provided for @tokenGuideDetail.
  ///
  /// In en, this message translates to:
  /// **'Permission setup depends on the token type.\n\n1. Fine-grained token (recommended)\nAccess can be limited to specific repositories.\n• Resource owner: your account\n• Repository access: Only select repositories → choose your notes repository\n• Repository permissions:\n   - Contents: Read and write (required)\n   - Metadata: Read-only (default)\n\n2. Personal access token (classic)\n• Under Select scopes, check \"repo\"\n• Sub-scopes (repo:status, public_repo, …) are selected automatically'**
  String get tokenGuideDetail;

  /// No description provided for @reRegisterToken.
  ///
  /// In en, this message translates to:
  /// **'Re-enter token'**
  String get reRegisterToken;

  /// No description provided for @securityNotice.
  ///
  /// In en, this message translates to:
  /// **'Security notice\n• Your token is stored only in this device\'s secure storage.\n• The token is never sent to logs or external services.\n• Logging out deletes the token immediately.'**
  String get securityNotice;

  /// No description provided for @selectRepository.
  ///
  /// In en, this message translates to:
  /// **'Select repository'**
  String get selectRepository;

  /// No description provided for @searchRepositoryHint.
  ///
  /// In en, this message translates to:
  /// **'Search repositories'**
  String get searchRepositoryHint;

  /// No description provided for @publicLabel.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get publicLabel;

  /// No description provided for @privateLabel.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get privateLabel;

  /// No description provided for @selectBranch.
  ///
  /// In en, this message translates to:
  /// **'Select branch'**
  String get selectBranch;

  /// No description provided for @selectRepoFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a repository first.'**
  String get selectRepoFirst;

  /// No description provided for @branchLabel.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get branchLabel;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current location: /{path}'**
  String currentLocation(String path);

  /// No description provided for @vaultRootHint.
  ///
  /// In en, this message translates to:
  /// **'To use this folder as the Vault root, tap the button below.'**
  String get vaultRootHint;

  /// No description provided for @goUpFolder.
  ///
  /// In en, this message translates to:
  /// **'Go to parent folder'**
  String get goUpFolder;

  /// No description provided for @noSubfolders.
  ///
  /// In en, this message translates to:
  /// **'No subfolders.'**
  String get noSubfolders;

  /// No description provided for @selectRootAsVault.
  ///
  /// In en, this message translates to:
  /// **'Use repository root (/) as Vault'**
  String get selectRootAsVault;

  /// No description provided for @selectFolderAsVault.
  ///
  /// In en, this message translates to:
  /// **'Use /{path} as Vault'**
  String selectFolderAsVault(String path);

  /// No description provided for @syncStarting.
  ///
  /// In en, this message translates to:
  /// **'Starting sync…'**
  String get syncStarting;

  /// No description provided for @newMemo.
  ///
  /// In en, this message translates to:
  /// **'New note'**
  String get newMemo;

  /// No description provided for @newMemoFileNameHint.
  ///
  /// In en, this message translates to:
  /// **'File name (.md added automatically)'**
  String get newMemoFileNameHint;

  /// No description provided for @newFolder.
  ///
  /// In en, this message translates to:
  /// **'New folder'**
  String get newFolder;

  /// No description provided for @folderNameHint.
  ///
  /// In en, this message translates to:
  /// **'Folder name'**
  String get folderNameHint;

  /// No description provided for @renameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get renameTitle;

  /// No description provided for @newFileNameHint.
  ///
  /// In en, this message translates to:
  /// **'New file name'**
  String get newFileNameHint;

  /// No description provided for @renameDone.
  ///
  /// In en, this message translates to:
  /// **'Renamed.'**
  String get renameDone;

  /// No description provided for @movingFile.
  ///
  /// In en, this message translates to:
  /// **'Moving…'**
  String get movingFile;

  /// No description provided for @moveDone.
  ///
  /// In en, this message translates to:
  /// **'Moved.'**
  String get moveDone;

  /// No description provided for @moveToRoot.
  ///
  /// In en, this message translates to:
  /// **'Drop here to move to the root folder'**
  String get moveToRoot;

  /// No description provided for @moveFolderMenu.
  ///
  /// In en, this message translates to:
  /// **'Move to folder…'**
  String get moveFolderMenu;

  /// No description provided for @folderPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose destination'**
  String get folderPickerTitle;

  /// No description provided for @moveHere.
  ///
  /// In en, this message translates to:
  /// **'Move here'**
  String get moveHere;

  /// No description provided for @movingFolder.
  ///
  /// In en, this message translates to:
  /// **'Moving folder…'**
  String get movingFolder;

  /// No description provided for @moveFolderConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will move {count} file(s) in this folder. A commit is created per file. Continue?'**
  String moveFolderConfirm(int count);

  /// No description provided for @moveFolderEmpty.
  ///
  /// In en, this message translates to:
  /// **'This folder has no files to move.'**
  String get moveFolderEmpty;

  /// No description provided for @moveFolderDone.
  ///
  /// In en, this message translates to:
  /// **'Moved {count} file(s).'**
  String moveFolderDone(int count);

  /// No description provided for @deleteFileTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete file'**
  String get deleteFileTitle;

  /// No description provided for @deleteFileConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?\nIt will also be deleted from GitHub on the next sync.'**
  String deleteFileConfirm(String name);

  /// No description provided for @newMemoInFolder.
  ///
  /// In en, this message translates to:
  /// **'New note in this folder'**
  String get newMemoInFolder;

  /// No description provided for @newFolderInFolder.
  ///
  /// In en, this message translates to:
  /// **'New folder in this folder'**
  String get newFolderInFolder;

  /// No description provided for @copyPath.
  ///
  /// In en, this message translates to:
  /// **'Copy path'**
  String get copyPath;

  /// No description provided for @pathCopied.
  ///
  /// In en, this message translates to:
  /// **'Path copied.'**
  String get pathCopied;

  /// No description provided for @markdownOnly.
  ///
  /// In en, this message translates to:
  /// **'Only Markdown files can be edited.'**
  String get markdownOnly;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'You are offline. Showing local files.'**
  String get offlineBanner;

  /// No description provided for @emptyFilesMessage.
  ///
  /// In en, this message translates to:
  /// **'No files yet.\nCreate a new note with the button below.'**
  String get emptyFilesMessage;

  /// No description provided for @statusSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get statusSaved;

  /// No description provided for @statusSavingLocal.
  ///
  /// In en, this message translates to:
  /// **'Saving locally'**
  String get statusSavingLocal;

  /// No description provided for @statusPendingSync.
  ///
  /// In en, this message translates to:
  /// **'Waiting to sync'**
  String get statusPendingSync;

  /// No description provided for @statusSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing'**
  String get statusSyncing;

  /// No description provided for @statusOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get statusOffline;

  /// No description provided for @statusConflict.
  ///
  /// In en, this message translates to:
  /// **'Conflict'**
  String get statusConflict;

  /// No description provided for @statusSyncFailed.
  ///
  /// In en, this message translates to:
  /// **'Sync failed'**
  String get statusSyncFailed;

  /// No description provided for @editTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editTooltip;

  /// No description provided for @previewTooltip.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get previewTooltip;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncNow;

  /// No description provided for @closeKeyboard.
  ///
  /// In en, this message translates to:
  /// **'Close keyboard'**
  String get closeKeyboard;

  /// No description provided for @resolveConflict.
  ///
  /// In en, this message translates to:
  /// **'Resolve conflict'**
  String get resolveConflict;

  /// No description provided for @conflictBanner.
  ///
  /// In en, this message translates to:
  /// **'The server file has changed and a conflict occurred. Your content is safely stored locally.'**
  String get conflictBanner;

  /// No description provided for @memoHint.
  ///
  /// In en, this message translates to:
  /// **'Write your note…'**
  String get memoHint;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search file names or content'**
  String get searchHint;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results.'**
  String get noResults;

  /// No description provided for @enterQuery.
  ///
  /// In en, this message translates to:
  /// **'Enter a search term.'**
  String get enterQuery;

  /// No description provided for @conflictNotFound.
  ///
  /// In en, this message translates to:
  /// **'Conflict information not found.'**
  String get conflictNotFound;

  /// No description provided for @serverVersionTab.
  ///
  /// In en, this message translates to:
  /// **'Server version\nchecked {time}'**
  String serverVersionTab(String time);

  /// No description provided for @localVersionTab.
  ///
  /// In en, this message translates to:
  /// **'My version\nedited {time}'**
  String localVersionTab(String time);

  /// No description provided for @serverContentMissing.
  ///
  /// In en, this message translates to:
  /// **'(The file was deleted on the server or its content could not be loaded)'**
  String get serverContentMissing;

  /// No description provided for @useServerVersion.
  ///
  /// In en, this message translates to:
  /// **'Use server version'**
  String get useServerVersion;

  /// No description provided for @overwriteWithMine.
  ///
  /// In en, this message translates to:
  /// **'Overwrite with my version'**
  String get overwriteWithMine;

  /// No description provided for @keepBothVersions.
  ///
  /// In en, this message translates to:
  /// **'Keep both versions as separate files'**
  String get keepBothVersions;

  /// No description provided for @resolveLater.
  ///
  /// In en, this message translates to:
  /// **'Resolve later'**
  String get resolveLater;

  /// No description provided for @useServerConfirm.
  ///
  /// In en, this message translates to:
  /// **'Replace with the server version. Your local edits will be lost.'**
  String get useServerConfirm;

  /// No description provided for @useMineConfirm.
  ///
  /// In en, this message translates to:
  /// **'Overwrite the server file with my version.'**
  String get useMineConfirm;

  /// No description provided for @keepBothConfirm.
  ///
  /// In en, this message translates to:
  /// **'Save my version as a conflict copy and restore the original to the server version.'**
  String get keepBothConfirm;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @githubAccount.
  ///
  /// In en, this message translates to:
  /// **'GitHub account'**
  String get githubAccount;

  /// No description provided for @changeToken.
  ///
  /// In en, this message translates to:
  /// **'Change token'**
  String get changeToken;

  /// No description provided for @changeVaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Change repository · branch · Vault root'**
  String get changeVaultTitle;

  /// No description provided for @autoSync.
  ///
  /// In en, this message translates to:
  /// **'Auto sync'**
  String get autoSync;

  /// No description provided for @autoSyncDelay.
  ///
  /// In en, this message translates to:
  /// **'Auto sync delay'**
  String get autoSyncDelay;

  /// No description provided for @autoSyncDelayDesc.
  ///
  /// In en, this message translates to:
  /// **'{n} seconds after typing stops'**
  String autoSyncDelayDesc(int n);

  /// No description provided for @secondsLabel.
  ///
  /// In en, this message translates to:
  /// **'{n}s'**
  String secondsLabel(int n);

  /// No description provided for @showHiddenFiles.
  ///
  /// In en, this message translates to:
  /// **'Show hidden files'**
  String get showHiddenFiles;

  /// No description provided for @showHiddenFilesDesc.
  ///
  /// In en, this message translates to:
  /// **'Include hidden folders such as .obsidian'**
  String get showHiddenFilesDesc;

  /// No description provided for @showNonMarkdown.
  ///
  /// In en, this message translates to:
  /// **'Show non-.md files'**
  String get showNonMarkdown;

  /// No description provided for @themeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeTitle;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @clearCacheTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear cache'**
  String get clearCacheTitle;

  /// No description provided for @clearCacheDesc.
  ///
  /// In en, this message translates to:
  /// **'Unsynced drafts are kept'**
  String get clearCacheDesc;

  /// No description provided for @clearCacheConfirmClean.
  ///
  /// In en, this message translates to:
  /// **'Delete the synced document cache. Continue?'**
  String get clearCacheConfirmClean;

  /// No description provided for @clearCacheConfirmDirty.
  ///
  /// In en, this message translates to:
  /// **'You have unsynced drafts!\nOnly the synced document cache will be deleted; unsynced drafts are kept. Continue?'**
  String get clearCacheConfirmDirty;

  /// No description provided for @cacheCleared.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared.'**
  String get cacheCleared;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logoutTitle;

  /// No description provided for @logoutConfirmClean.
  ///
  /// In en, this message translates to:
  /// **'This deletes your token and all local data. Continue?'**
  String get logoutConfirmClean;

  /// No description provided for @logoutConfirmDirty.
  ///
  /// In en, this message translates to:
  /// **'You have unsynced drafts!\nLogging out deletes your token and ALL local data, including unsynced drafts.'**
  String get logoutConfirmDirty;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get appVersion;

  /// No description provided for @syncNoChanges.
  ///
  /// In en, this message translates to:
  /// **'Nothing to sync.'**
  String get syncNoChanges;

  /// No description provided for @syncUploadedCount.
  ///
  /// In en, this message translates to:
  /// **'{n} uploaded'**
  String syncUploadedCount(int n);

  /// No description provided for @syncDeletedCount.
  ///
  /// In en, this message translates to:
  /// **'{n} deleted'**
  String syncDeletedCount(int n);

  /// No description provided for @syncConflictCount.
  ///
  /// In en, this message translates to:
  /// **'{n} conflicts'**
  String syncConflictCount(int n);

  /// No description provided for @syncFailedCount.
  ///
  /// In en, this message translates to:
  /// **'{n} failed'**
  String syncFailedCount(int n);

  /// No description provided for @errNetwork.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection.'**
  String get errNetwork;

  /// No description provided for @errUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'The token is invalid. Please check it again.'**
  String get errUnauthorized;

  /// No description provided for @errPermission.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission for the selected repository.'**
  String get errPermission;

  /// No description provided for @errRateLimit.
  ///
  /// In en, this message translates to:
  /// **'GitHub API rate limit reached. Please try again later.'**
  String get errRateLimit;

  /// No description provided for @errNotFound.
  ///
  /// In en, this message translates to:
  /// **'The requested item was not found.'**
  String get errNotFound;

  /// No description provided for @errConflict.
  ///
  /// In en, this message translates to:
  /// **'The file changed on the server and a conflict occurred.'**
  String get errConflict;

  /// No description provided for @errLocalStorage.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while saving locally.'**
  String get errLocalStorage;

  /// No description provided for @errUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred.'**
  String get errUnknown;

  /// No description provided for @errNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter a file name.'**
  String get errNameEmpty;

  /// No description provided for @errNameSlash.
  ///
  /// In en, this message translates to:
  /// **'File names cannot contain \"/\".'**
  String get errNameSlash;

  /// No description provided for @errNameDots.
  ///
  /// In en, this message translates to:
  /// **'File names cannot contain \"..\".'**
  String get errNameDots;

  /// No description provided for @errNameSpecial.
  ///
  /// In en, this message translates to:
  /// **'File names cannot contain \\ : * ? \" < > | characters.'**
  String get errNameSpecial;

  /// No description provided for @errNameDuplicate.
  ///
  /// In en, this message translates to:
  /// **'A file with the same name already exists.'**
  String get errNameDuplicate;

  /// No description provided for @errRenamePartial.
  ///
  /// In en, this message translates to:
  /// **'The new file was created but deleting the old file failed. It will be retried during sync.'**
  String get errRenamePartial;

  /// No description provided for @errMoveIntoSelf.
  ///
  /// In en, this message translates to:
  /// **'You can\'t move a folder into itself or one of its subfolders.'**
  String get errMoveIntoSelf;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
