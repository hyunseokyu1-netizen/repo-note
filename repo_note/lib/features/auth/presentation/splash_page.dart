import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/gen/app_localizations.dart';
import 'session_controller.dart';

/// 최소 초기화만 수행하고 다음 화면으로 이동한다.
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_route);
  }

  Future<void> _route() async {
    final session = await ref.read(sessionControllerProvider.future);
    if (!mounted) return;
    if (!session.hasToken) {
      context.go('/setup/token');
    } else if (session.vault == null) {
      context.go('/setup/repository');
    } else {
      context.go('/files');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sticky_note_2_outlined,
              size: 72,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text('RepoNote', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context).appTagline,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
