# RepoNote

**English** | [한국어](README.ko.md)

A personal mobile note-taking app (Flutter) that treats a GitHub repository as an Obsidian vault.

It reads, creates, edits, and deletes Markdown files through the GitHub REST API (Contents API),
syncing each save as a commit. No Git CLI, no full clone, no SSH keys.

## Why I built this

Connecting Obsidian to Git on mobile was far too complicated. Plugin setup is tedious,
and once a conflict happens, resolving it on a phone screen is genuinely painful.

So I built a note app that **syncs automatically with my Obsidian repository on GitHub**.
Open it, write, and it commits for you. When a conflict occurs, you compare both versions
and pick one — no merge markers.

The first version was built with React Native, but it had too many errors,
so I rebuilt it from scratch in Flutter using the same spec document.

## Features (MVP)

- Register and validate a GitHub fine-grained personal access token
- Pick a repository / branch / vault root folder
- Browse folders and Markdown files in a collapsible tree (`.obsidian` and hidden files hidden by default)
- Plain-text Markdown editing with preview
- Local auto-save (600ms debounce) — local storage always comes before the network
- Auto-commit to GitHub (5s after typing stops, configurable) and manual sync
- New note / new folder / rename / delete (tombstone until the server confirms)
- Search across file names and locally cached content
- SHA-based conflict detection with a resolution screen (server version / mine / keep both / later)
- Offline editing with automatic sync on reconnect (exponential backoff retry)
- Dark mode (system / light / dark), English & Korean localization

## Tech stack

| Area | Package |
|---|---|
| State management | flutter_riverpod (Notifier / AsyncNotifier) |
| Routing | go_router |
| Networking | dio (GitHub REST API, shared interceptor) |
| Credentials | flutter_secure_storage (token lives here only) |
| Local DB | drift + sqlite3_flutter_libs |
| File cache | path_provider + crypto (hashed paths) |
| Connectivity | connectivity_plus |
| Preview | flutter_markdown_plus |

## Architecture

Feature-first + repository pattern.

```text
lib/
├── app/            # App, router, theme
├── core/
│   ├── errors/     # AppFailure (user messages separated)
│   ├── network/    # GitHubApiClient, DTOs
│   ├── storage/    # Drift DB, secure storage, file cache
│   └── utils/      # File name validation, Base64 codec, debouncer, conflict detection
└── features/
    ├── auth/                 # Token registration/validation, session
    ├── repository_selection/ # Repository · branch · vault root selection
    ├── file_browser/         # Tree browsing + NotesRepository
    ├── editor/               # Editor, auto-save
    ├── sync/                 # SyncCoordinator (serial processing, retry, conflicts)
    ├── search/               # Local search
    ├── conflict/             # Conflict resolution
    └── settings/             # Settings
```

Boundary rules: the UI never calls Dio or Drift DAOs directly, and GitHub DTOs never reach the screen layer.

## Getting started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # generate Drift code
flutter run
```

## Tests

```bash
flutter analyze
flutter test
```

Unit tests: file name validation, path normalization, Base64 encode/decode, SHA conflict detection, debounce, auth header handling.
Widget tests: token setup screen (en/ko locales).

## Build & install on a device

```bash
flutter build apk --release
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

## Preparing a GitHub token

1. GitHub → Settings → Developer settings → **Fine-grained personal access tokens**
2. Restrict repository access to your notes repository only
3. Permissions: **Contents: Read and write**, **Metadata: Read-only**

## Platform notes

### Android

- `android/app/src/main/AndroidManifest.xml`
  - `INTERNET` and `ACCESS_NETWORK_STATE` permissions only (minimal)
  - App label: `RepoNote`
- `android/app/build.gradle.kts`
  - `applicationId = "com.backdev.reponote"` (confirm before store release)
  - Release builds currently use debug signing → a signing key is required for store distribution

### iOS

- No extra permissions (HTTPS only)
- `flutter build ios` works after configuring Xcode signing

## Security

- The token is stored only in `flutter_secure_storage` (never in SharedPreferences, the DB, or logs)
- All communication is HTTPS; the token travels only in the Authorization header
- Tokens and note contents are never written to logs
- Logging out deletes the token and all local data

## Docs

- [Original spec document (Korean)](docs/obsidian_git_mobile_app_flutter_spec.md)
