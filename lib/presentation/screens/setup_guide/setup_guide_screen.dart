import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../providers/settings_provider.dart';

/// First-run setup guide. Shown by the splash screen whenever the app
/// isn't fully configured yet (no valid server, or not logged in) — and
/// keeps reappearing on every app launch until setup is actually completed,
/// since it's driven by real persisted settings state, not a "seen it" flag.
class SetupGuideScreen extends ConsumerWidget {
  const SetupGuideScreen({super.key});

  static const _patchUrl = 'https://sp9aqg.pl/install.html';

  void _continue(BuildContext context, WidgetRef ref) {
    final settings = ref.read(settingsProvider);
    if (!settings.hasValidConfig) {
      context.go('/server-setup');
    } else {
      context.go('/login');
    }
  }

  Future<void> _openPatch() async {
    final uri = Uri.parse(_patchUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.setupGuideTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Icon(
              Icons.cell_tower,
              size: 56,
              color: cs.primary,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.setupGuideIntro,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: cs.secondary,
                  ),
            ),
            const SizedBox(height: 16),

            // Patch requirement warning banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cs.errorContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.error.withValues(alpha: 0.4)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber_rounded, color: cs.error, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.setupGuidePatchWarning,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: cs.onErrorContainer,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Patch install step (step 0)
            _GuideStep(
              icon: Icons.download_rounded,
              title: l10n.setupGuidePatchStepTitle,
              body: l10n.setupGuidePatchStepBody,
              action: TextButton.icon(
                onPressed: _openPatch,
                icon: const Icon(Icons.open_in_browser, size: 16),
                label: Text(l10n.setupGuidePatchBtn),
              ),
            ),

            _GuideStep(
              icon: Icons.link,
              title: l10n.setupGuideStep1Title,
              body: l10n.setupGuideStep1Body,
            ),
            _GuideStep(
              icon: Icons.key,
              title: l10n.setupGuideStep2Title,
              body: l10n.setupGuideStep2Body,
            ),
            _GuideStep(
              icon: Icons.person_outline,
              title: l10n.setupGuideStep3Title,
              body: l10n.setupGuideStep3Body,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _continue(context, ref),
              icon: const Icon(Icons.arrow_forward),
              label: Text(l10n.setupGuideContinueBtn),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final Widget? action;

  const _GuideStep({
    required this.icon,
    required this.title,
    required this.body,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: cs.primaryContainer,
            child: Icon(icon, size: 18, color: cs.onPrimaryContainer),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                ),
                if (action != null) ...[
                  const SizedBox(height: 4),
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
