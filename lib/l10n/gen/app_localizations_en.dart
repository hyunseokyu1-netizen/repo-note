// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTagline => 'GitHub repository notepad';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get proceed => 'Proceed';

  @override
  String get retry => 'Retry';

  @override
  String get confirmTitle => 'Confirm';

  @override
  String get githubConnect => 'Connect GitHub';

  @override
  String get tokenGuideBody =>
      'We recommend a token that can only access your note repository.\nRequired permissions: Repository contents (Read and write), Metadata (Read-only)';

  @override
  String get tokenLabel => 'GitHub Token';

  @override
  String get tokenEmpty => 'Please enter a token.';

  @override
  String get verifyConnection => 'Verify connection';

  @override
  String get tokenIssueGuide => 'Open GitHub token settings';

  @override
  String get tokenGuideDetailTitle => 'How to set token permissions';

  @override
  String get tokenGuideDetail =>
      'Permission setup depends on the token type.\n\n1. Fine-grained token (recommended)\nAccess can be limited to specific repositories.\n• Resource owner: your account\n• Repository access: Only select repositories → choose your notes repository\n• Repository permissions:\n   - Contents: Read and write (required)\n   - Metadata: Read-only (default)\n\n2. Personal access token (classic)\n• Under Select scopes, check \"repo\"\n• Sub-scopes (repo:status, public_repo, …) are selected automatically';

  @override
  String get reRegisterToken => 'Re-enter token';

  @override
  String get securityNotice =>
      'Security notice\n• Your token is stored only in this device\'s secure storage.\n• The token is never sent to logs or external services.\n• Logging out deletes the token immediately.';

  @override
  String get selectRepository => 'Select repository';

  @override
  String get searchRepositoryHint => 'Search repositories';

  @override
  String get publicLabel => 'Public';

  @override
  String get privateLabel => 'Private';

  @override
  String get selectBranch => 'Select branch';

  @override
  String get selectRepoFirst => 'Please select a repository first.';

  @override
  String get branchLabel => 'Branch';

  @override
  String currentLocation(String path) {
    return 'Current location: /$path';
  }

  @override
  String get vaultRootHint =>
      'To use this folder as the Vault root, tap the button below.';

  @override
  String get goUpFolder => 'Go to parent folder';

  @override
  String get noSubfolders => 'No subfolders.';

  @override
  String get selectRootAsVault => 'Use repository root (/) as Vault';

  @override
  String selectFolderAsVault(String path) {
    return 'Use /$path as Vault';
  }

  @override
  String get syncStarting => 'Starting sync…';

  @override
  String get newMemo => 'New note';

  @override
  String get newMemoFileNameHint => 'File name (.md added automatically)';

  @override
  String get newFolder => 'New folder';

  @override
  String get folderNameHint => 'Folder name';

  @override
  String get renameTitle => 'Rename';

  @override
  String get newFileNameHint => 'New file name';

  @override
  String get renameDone => 'Renamed.';

  @override
  String get movingFile => 'Moving…';

  @override
  String get moveDone => 'Moved.';

  @override
  String get moveToRoot => 'Drop here to move to the root folder';

  @override
  String get moveFolderMenu => 'Move to folder…';

  @override
  String get folderPickerTitle => 'Choose destination';

  @override
  String get moveHere => 'Move here';

  @override
  String get movingFolder => 'Moving folder…';

  @override
  String moveFolderConfirm(int count) {
    return 'This will move $count file(s) in this folder. A commit is created per file. Continue?';
  }

  @override
  String get moveFolderEmpty => 'This folder has no files to move.';

  @override
  String moveFolderDone(int count) {
    return 'Moved $count file(s).';
  }

  @override
  String get deleteFileTitle => 'Delete file';

  @override
  String deleteFileConfirm(String name) {
    return 'Delete $name?\nIt will also be deleted from GitHub on the next sync.';
  }

  @override
  String get newMemoInFolder => 'New note in this folder';

  @override
  String get newFolderInFolder => 'New folder in this folder';

  @override
  String get copyPath => 'Copy path';

  @override
  String get pathCopied => 'Path copied.';

  @override
  String get markdownOnly => 'Only Markdown files can be edited.';

  @override
  String get offlineBanner => 'You are offline. Showing local files.';

  @override
  String get emptyFilesMessage =>
      'No files yet.\nCreate a new note with the button below.';

  @override
  String get statusSaved => 'Saved';

  @override
  String get statusSavingLocal => 'Saving locally';

  @override
  String get statusPendingSync => 'Waiting to sync';

  @override
  String get statusSyncing => 'Syncing';

  @override
  String get statusOffline => 'Offline';

  @override
  String get statusConflict => 'Conflict';

  @override
  String get statusSyncFailed => 'Sync failed';

  @override
  String get editTooltip => 'Edit';

  @override
  String get previewTooltip => 'Preview';

  @override
  String get syncNow => 'Sync now';

  @override
  String get closeKeyboard => 'Close keyboard';

  @override
  String get resolveConflict => 'Resolve conflict';

  @override
  String get conflictBanner =>
      'The server file has changed and a conflict occurred. Your content is safely stored locally.';

  @override
  String get memoHint => 'Write your note…';

  @override
  String wikiLinkNotFound(String name) {
    return 'Note not found: $name';
  }

  @override
  String get searchHint => 'Search file names or content';

  @override
  String get noResults => 'No results.';

  @override
  String get enterQuery => 'Enter a search term.';

  @override
  String get conflictNotFound => 'Conflict information not found.';

  @override
  String serverVersionTab(String time) {
    return 'Server version\nchecked $time';
  }

  @override
  String localVersionTab(String time) {
    return 'My version\nedited $time';
  }

  @override
  String get serverContentMissing =>
      '(The file was deleted on the server or its content could not be loaded)';

  @override
  String get useServerVersion => 'Use server version';

  @override
  String get overwriteWithMine => 'Overwrite with my version';

  @override
  String get keepBothVersions => 'Keep both versions as separate files';

  @override
  String get resolveLater => 'Resolve later';

  @override
  String get useServerConfirm =>
      'Replace with the server version. Your local edits will be lost.';

  @override
  String get useMineConfirm => 'Overwrite the server file with my version.';

  @override
  String get keepBothConfirm =>
      'Save my version as a conflict copy and restore the original to the server version.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get githubAccount => 'GitHub account';

  @override
  String get changeToken => 'Change token';

  @override
  String get changeVaultTitle => 'Change repository · branch · Vault root';

  @override
  String get autoSync => 'Auto sync';

  @override
  String get autoSyncDelay => 'Auto sync delay';

  @override
  String autoSyncDelayDesc(int n) {
    return '$n seconds after typing stops';
  }

  @override
  String secondsLabel(int n) {
    return '${n}s';
  }

  @override
  String get showHiddenFiles => 'Show hidden files';

  @override
  String get showHiddenFilesDesc => 'Include hidden folders such as .obsidian';

  @override
  String get showNonMarkdown => 'Show non-.md files';

  @override
  String get themeTitle => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get clearCacheTitle => 'Clear cache';

  @override
  String get clearCacheDesc => 'Unsynced drafts are kept';

  @override
  String get clearCacheConfirmClean =>
      'Delete the synced document cache. Continue?';

  @override
  String get clearCacheConfirmDirty =>
      'You have unsynced drafts!\nOnly the synced document cache will be deleted; unsynced drafts are kept. Continue?';

  @override
  String get cacheCleared => 'Cache cleared.';

  @override
  String get logoutTitle => 'Log out';

  @override
  String get logoutConfirmClean =>
      'This deletes your token and all local data. Continue?';

  @override
  String get logoutConfirmDirty =>
      'You have unsynced drafts!\nLogging out deletes your token and ALL local data, including unsynced drafts.';

  @override
  String get appVersion => 'App version';

  @override
  String get syncNoChanges => 'Nothing to sync.';

  @override
  String syncUploadedCount(int n) {
    return '$n uploaded';
  }

  @override
  String syncDeletedCount(int n) {
    return '$n deleted';
  }

  @override
  String syncConflictCount(int n) {
    return '$n conflicts';
  }

  @override
  String syncFailedCount(int n) {
    return '$n failed';
  }

  @override
  String get errNetwork => 'Please check your internet connection.';

  @override
  String get errUnauthorized => 'The token is invalid. Please check it again.';

  @override
  String get errPermission =>
      'You don\'t have permission for the selected repository.';

  @override
  String get errRateLimit =>
      'GitHub API rate limit reached. Please try again later.';

  @override
  String get errNotFound => 'The requested item was not found.';

  @override
  String get errConflict =>
      'The file changed on the server and a conflict occurred.';

  @override
  String get errLocalStorage => 'An error occurred while saving locally.';

  @override
  String get errUnknown => 'An unknown error occurred.';

  @override
  String get errNameEmpty => 'Please enter a file name.';

  @override
  String get errNameSlash => 'File names cannot contain \"/\".';

  @override
  String get errNameDots => 'File names cannot contain \"..\".';

  @override
  String get errNameSpecial =>
      'File names cannot contain \\ : * ? \" < > | characters.';

  @override
  String get errNameDuplicate => 'A file with the same name already exists.';

  @override
  String get errRenamePartial =>
      'The new file was created but deleting the old file failed. It will be retried during sync.';

  @override
  String get errMoveIntoSelf =>
      'You can\'t move a folder into itself or one of its subfolders.';
}
