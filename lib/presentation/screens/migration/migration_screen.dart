import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../data/datasources/remote/wavelog_remote_datasource.dart';
import '../../../providers/dio_provider.dart';
import '../../../providers/settings_provider.dart';

class MigrationScreen extends ConsumerStatefulWidget {
  const MigrationScreen({super.key});

  @override
  ConsumerState<MigrationScreen> createState() => _MigrationScreenState();
}

class _MigrationScreenState extends ConsumerState<MigrationScreen> {
  static const _patchUrl = 'https://sp9aqg.pl/install.html';

  final _tokenCtrl = TextEditingController();
  bool _validating = false;
  String? _tokenError;

  @override
  void dispose() {
    _tokenCtrl.dispose();
    super.dispose();
  }

  Future<void> _openPatch() async {
    final uri = Uri.parse(_patchUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _validateAndSave() async {
    final l10n = context.l10n;
    final token = _tokenCtrl.text.trim();

    if (!token.startsWith('wl2_') || token.length < 10) {
      setState(() => _tokenError = l10n.migrationTokenEmpty);
      return;
    }

    setState(() {
      _validating = true;
      _tokenError = null;
    });

    final serverUrl = ref.read(settingsProvider).serverUrl;
    try {
      final remote = WavelogRemoteDatasource(
        dio: buildWavelogDio(serverUrl, bearerToken: token),
      );
      await remote.getStations();
      // Success — patch installed and token valid
      await ref.read(settingsProvider.notifier).updateApiKey(token);
      if (mounted) context.go('/home');
    } on UnauthorizedException {
      // 401 — patch IS installed but token is wrong
      setState(() {
        _validating = false;
        _tokenError = l10n.migrationTokenInvalid;
      });
    } catch (_) {
      // Other error — patch likely not installed
      setState(() => _validating = false);
      if (mounted) _showPatchNotInstalledDialog();
    }
  }

  void _showPatchNotInstalledDialog() {
    final l10n = context.l10n;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.patchNotInstalledTitle),
        content: Text(l10n.patchNotInstalledBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _openPatch();
            },
            child: Text(l10n.patchInstallFirst),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.upgrade_rounded, size: 44, color: cs.primary),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.migrationTitle,
                  style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.migrationBody,
                  style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),

                _StepCard(
                  number: '1',
                  icon: Icons.download_rounded,
                  title: l10n.migrationStep1Title,
                  body: l10n.migrationStep1Body,
                  action: TextButton.icon(
                    onPressed: _openPatch,
                    icon: const Icon(Icons.open_in_browser, size: 18),
                    label: Text(l10n.migrationInstallGuideBtn),
                  ),
                ),

                _StepCard(
                  number: '2',
                  icon: Icons.key_rounded,
                  title: l10n.migrationStep2Title,
                  body: l10n.migrationStep2Body,
                ),

                _StepCard(
                  number: '3',
                  icon: Icons.settings_rounded,
                  title: l10n.migrationStep3Title,
                  body: l10n.migrationStep3Body,
                ),

                const SizedBox(height: 8),

                // Inline token entry + validation
                TextField(
                  controller: _tokenCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.migrationTokenLabel,
                    hintText: l10n.migrationTokenHint,
                    errorText: _tokenError,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.vpn_key_outlined),
                  ),
                  autocorrect: false,
                  enableSuggestions: false,
                  onSubmitted: (_) => _validateAndSave(),
                ),

                const SizedBox(height: 12),

                FilledButton.icon(
                  onPressed: _validating ? null : _validateAndSave,
                  icon: _validating
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check_circle_outline_rounded),
                  label: Text(_validating
                      ? l10n.migrationValidating
                      : l10n.migrationValidateBtn),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                ),

                const SizedBox(height: 12),

                OutlinedButton.icon(
                  onPressed: _openPatch,
                  icon: const Icon(Icons.help_outline_rounded, size: 18),
                  label: Text(l10n.migrationHelpBtn),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String number;
  final IconData icon;
  final String title;
  final String body;
  final Widget? action;

  const _StepCard({
    required this.number,
    required this.icon,
    required this.title,
    required this.body,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: cs.onPrimaryContainer),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        number,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: cs.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                        height: 1.5,
                      ),
                ),
                if (action != null) ...[
                  const SizedBox(height: 8),
                  action!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
