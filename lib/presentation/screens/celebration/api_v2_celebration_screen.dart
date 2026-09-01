import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/l10n_extension.dart';

const _prefKey = 'wavelog_v32_patch_notice_shown';

// Scope keys — each maps to a (scope_name, l10n_key) pair.
// l10n descriptions are fetched in the widget below.
const _scopeNames = [
  'qso:read',
  'qso:write',
  'station:read',
  'station:write',
  'logbook:read',
  'logbook:write',
  'contest:read',
  'contest:write',
  'catalog:read',
  'lookup:read',
  'statistics:read',
  'confirmation:read',
];

class ApiV2CelebrationScreen extends StatefulWidget {
  const ApiV2CelebrationScreen({super.key});

  static Future<bool> shouldShow() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_prefKey) ?? false);
  }

  static Future<void> markShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, true);
  }

  @override
  State<ApiV2CelebrationScreen> createState() => _ApiV2CelebrationScreenState();
}

class _ApiV2CelebrationScreenState extends State<ApiV2CelebrationScreen> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _page == 0
              ? _WelcomePage(onNext: () => setState(() => _page = 1))
              : const _ScopesPage(),
        ),
      ),
    );
  }
}

class _WelcomePage extends StatelessWidget {
  final VoidCallback onNext;
  const _WelcomePage({required this.onNext});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Padding(
      key: const ValueKey('welcome'),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Icon(Icons.celebration_rounded, size: 80, color: cs.primary),
          const SizedBox(height: 24),
          Text(
            l10n.celebTitle,
            style: tt.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.celebSubtitle,
            style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.celebBody,
            style: tt.bodyLarge?.copyWith(
              color: cs.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          FilledButton.icon(
            onPressed: onNext,
            icon: const Icon(Icons.arrow_forward),
            label: Text(l10n.celebCreateToken,
                style: const TextStyle(fontSize: 16)),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () async {
              await ApiV2CelebrationScreen.markShown();
              if (context.mounted) context.go('/home');
            },
            child: Text(l10n.celebSkip),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ScopesPage extends StatelessWidget {
  const _ScopesPage();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final l10n = context.l10n;

    final scopeDescs = [
      l10n.scopeQsoRead,
      l10n.scopeQsoWrite,
      l10n.scopeStationRead,
      l10n.scopeStationWrite,
      l10n.scopeLogbookRead,
      l10n.scopeLogbookWrite,
      l10n.scopeContestRead,
      l10n.scopeContestWrite,
      l10n.scopeCatalogRead,
      l10n.scopeLookupRead,
      l10n.scopeStatisticsRead,
      l10n.scopeConfirmationRead,
    ];

    return Padding(
      key: const ValueKey('scopes'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.vpn_key_outlined, color: cs.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.celebScopesTitle,
                    style:
                        tt.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Text(
              l10n.celebScopesBody,
              style: tt.bodyMedium
                  ?.copyWith(color: cs.onSurfaceVariant, height: 1.4),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: _scopeNames.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (ctx, i) {
                return ListTile(
                  dense: true,
                  leading: Icon(Icons.check_circle_outline,
                      color: cs.primary, size: 20),
                  title: Text(
                    _scopeNames[i],
                    style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    scopeDescs[i],
                    style: TextStyle(
                        fontSize: 12, color: cs.onSurfaceVariant),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: FilledButton(
              onPressed: () async {
                await ApiV2CelebrationScreen.markShown();
                if (context.mounted) context.go('/home');
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
              child: Text(l10n.celebDone,
                  style: const TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
