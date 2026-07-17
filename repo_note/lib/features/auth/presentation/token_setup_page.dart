import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/errors/failure_messages.dart';
import '../../../l10n/gen/app_localizations.dart';
import 'session_controller.dart';

class TokenSetupPage extends ConsumerStatefulWidget {
  const TokenSetupPage({super.key});

  @override
  ConsumerState<TokenSetupPage> createState() => _TokenSetupPageState();
}

class _TokenSetupPageState extends ConsumerState<TokenSetupPage> {
  final _controller = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    final l10n = AppLocalizations.of(context);
    final token = _controller.text.trim();
    if (token.isEmpty) {
      setState(() => _errorMessage = l10n.tokenEmpty);
      return;
    }
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      await ref.read(sessionControllerProvider.notifier).registerToken(token);
      if (mounted) context.go('/setup/repository');
    } on AppFailure catch (e) {
      if (mounted) setState(() => _errorMessage = failureMessage(context, e));
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = AppLocalizations.of(context).errUnknown);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.githubConnect)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Fine-grained Personal Access Token',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.tokenGuideBody,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              obscureText: _obscure,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                labelText: l10n.tokenLabel,
                errorText: _errorMessage,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _loading ? null : _connect,
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.verifyConnection),
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              icon: const Icon(Icons.open_in_new, size: 18),
              label: Text(l10n.tokenIssueGuide),
              onPressed: () => launchUrl(
                Uri.parse('https://github.com/settings/personal-access-tokens'),
                mode: LaunchMode.externalApplication,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.tokenGuideDetailTitle,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.tokenGuideDetail,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  l10n.securityNotice,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
