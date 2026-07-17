import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/splash_page.dart';
import '../features/auth/presentation/token_setup_page.dart';
import '../features/conflict/presentation/conflict_page.dart';
import '../features/editor/presentation/editor_page.dart';
import '../features/file_browser/presentation/file_browser_page.dart';
import '../features/repository_selection/presentation/branch_vault_page.dart';
import '../features/repository_selection/presentation/repository_page.dart';
import '../features/search/presentation/search_page.dart';
import '../features/settings/presentation/settings_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
      GoRoute(
        path: '/setup/token',
        builder: (context, state) => const TokenSetupPage(),
      ),
      GoRoute(
        path: '/setup/repository',
        builder: (context, state) => const RepositoryPage(),
      ),
      GoRoute(
        path: '/setup/branch',
        builder: (context, state) => const BranchVaultPage(),
      ),
      GoRoute(
        path: '/files',
        builder: (context, state) => const FileBrowserPage(),
      ),
      GoRoute(
        path: '/editor',
        builder: (context, state) =>
            EditorPage(fileId: state.uri.queryParameters['fileId'] ?? ''),
      ),
      GoRoute(path: '/search', builder: (context, state) => const SearchPage()),
      GoRoute(
        path: '/conflict',
        builder: (context, state) =>
            ConflictPage(fileId: state.uri.queryParameters['fileId'] ?? ''),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
});
