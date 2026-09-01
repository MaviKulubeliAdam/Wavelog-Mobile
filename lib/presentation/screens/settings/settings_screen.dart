import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/band_mode_data.dart';
import '../../../core/utils/error_l10n.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/utils/validators.dart';
import '../../../data/datasources/remote/wavelog_remote_datasource.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../providers/dio_provider.dart';
import '../../../providers/qso_provider.dart';
import '../../../providers/remote_datasource_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/station_provider.dart';
import '../../../providers/statistics_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _urlCtrl;
  late TextEditingController _keyCtrl;
  bool _keyObscure = true;
  bool _testing = false;
  String? _testResult;
  bool _testSuccess = false;

  @override
  void initState() {
    super.initState();
    final s = ref.read(settingsProvider);
    _urlCtrl = TextEditingController(text: s.serverUrl);
    _keyCtrl = TextEditingController(text: s.apiKey);
  }

  @override
  void dispose() {
    _urlCtrl.dispose();
    _keyCtrl.dispose();
    super.dispose();
  }

  Future<void> _save({bool navigate = true}) async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(settingsProvider.notifier).updateServerUrl(_urlCtrl.text);
    await ref.read(settingsProvider.notifier).updateApiKey(_keyCtrl.text);
    // Force data providers to reload with the new token immediately.
    ref.invalidate(stationProvider);
    ref.invalidate(qsoProvider);
    ref.invalidate(statisticsProvider);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.success),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
    if (navigate) {
      final settings = ref.read(settingsProvider);
      if (settings.isLoggedIn) {
        context.go('/home');
      } else {
        context.go('/login');
      }
    }
  }

  Future<void> _testConnection() async {
    if (!_formKey.currentState!.validate()) return;
    await _save(navigate: false);

    setState(() {
      _testing = true;
      _testResult = null;
    });

    final repo = ref.read(settingsRepositoryProvider);
    final remote = WavelogRemoteDatasource(
      dio: buildWavelogDio(_urlCtrl.text.trim(),
          bearerToken: _keyCtrl.text.trim()),
    );

    ConnectionTestResult result;
    try {
      result = await repo.testConnection(remote);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _testing = false;
        _testSuccess = false;
        _testResult = localizeError(context, e);
      });
      return;
    }

    if (!mounted) return;
    ref.invalidate(stationProvider);
    ref.invalidate(qsoProvider);
    ref.invalidate(statisticsProvider);
    try {
      final stations = await ref.read(stationProvider.future);
      if (stations.isNotEmpty && mounted) {
        final current = ref.read(settingsProvider).activeStationProfileId;
        final active = stations.where((s) => s.id == current).firstOrNull
            ?? stations.where((s) => s.isActive).firstOrNull
            ?? stations.first;
        await ref.read(settingsProvider.notifier).setActiveStation(active);
      }
    } catch (_) {}

    if (!mounted) return;
    setState(() {
      _testing = false;
      _testSuccess = true;
      final label = result.message ?? context.l10n.connectionSuccess;
      _testResult = result.totalQsos != null
          ? '$label — ${result.totalQsos} QSO'
          : label;
    });

    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      final settings = ref.read(settingsProvider);
      context.go(settings.isLoggedIn ? '/home' : '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider);
    final stations = ref.watch(stationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        actions: [
          TextButton(onPressed: _save, child: Text(l10n.save)),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Connection section
            _sectionHeader(l10n.connectionSection),
            TextFormField(
              controller: _urlCtrl,
              decoration: InputDecoration(
                labelText: '${l10n.serverUrlLabel} *',
                hintText: l10n.serverUrlHint,
                prefixIcon: const Icon(Icons.link),
              ),
              keyboardType: TextInputType.url,
              autocorrect: false,
              validator: validateServerUrl,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _keyCtrl,
              decoration: InputDecoration(
                labelText: '${l10n.apiKeyLabel} *',
                prefixIcon: const Icon(Icons.key),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(_keyObscure
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () =>
                          setState(() => _keyObscure = !_keyObscure),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: _keyCtrl.text));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.apiKeyCopied)),
                        );
                      },
                    ),
                  ],
                ),
              ),
              obscureText: _keyObscure,
              validator: validateApiKey,
            ),
            const SizedBox(height: 12),

            // Test connection
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _testing ? null : _testConnection,
                    icon: _testing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.wifi_find),
                    label: Text(_testing
                        ? l10n.testingConnection
                        : l10n.testConnection),
                  ),
                ),
              ],
            ),
            if (_testResult != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Icon(
                      _testSuccess ? Icons.check_circle : Icons.error,
                      color: _testSuccess ? Colors.green : Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _testResult!,
                        style: TextStyle(
                          color: _testSuccess ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Logged-in account
            if (settings.isLoggedIn) ...[
              _sectionHeader(l10n.sessionSection),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.account_circle),
                title: Text(settings.activeStationCallsign ?? l10n.loggedIn),
                subtitle: Text(
                    settings.activeStationName ?? settings.activeProfileId ?? ''),
                trailing: TextButton.icon(
                  icon: const Icon(Icons.logout, size: 16),
                  label: Text(l10n.logoutBtn),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (dialogCtx) => AlertDialog(
                        title: Text(l10n.logoutTitle),
                        content: Text(l10n.logoutConfirm),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogCtx, false),
                            child: Text(l10n.cancel),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(dialogCtx, true),
                            child: Text(l10n.logoutBtn),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true && context.mounted) {
                      await ref.read(settingsProvider.notifier).logout();
                      if (context.mounted) context.go('/login');
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => context.push('/login'),
                icon: const Icon(Icons.switch_account_outlined, size: 16),
                label: Text(l10n.switchAccountBtn),
              ),
              const SizedBox(height: 16),
            ],

            // Active station
            _sectionHeader(l10n.activeStationSection),
            stations.when(
              data: (list) {
                if (list.isEmpty) {
                  return OutlinedButton.icon(
                    onPressed: () async {
                      final url = Uri.parse(
                          '${ref.read(settingsProvider).serverUrl}/index.php/station');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url,
                            mode: LaunchMode.externalApplication);
                      }
                    },
                    icon: const Icon(Icons.open_in_browser),
                    label: Text(l10n.addStationWeb),
                  );
                }
                return Column(
                  children: [
                    if (settings.activeStationCallsign != null)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.cell_tower),
                        title: Text(settings.activeStationCallsign!),
                        subtitle: Text(settings.activeStationName ?? ''),
                        trailing: TextButton(
                          onPressed: () => context.push('/station-picker'),
                          child: Text(l10n.change),
                        ),
                      )
                    else
                      OutlinedButton.icon(
                        onPressed: () => context.push('/station-picker'),
                        icon: const Icon(Icons.cell_tower),
                        label: Text(l10n.selectStationBtn),
                      ),
                  ],
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const SizedBox.shrink(),
            ),

            const SizedBox(height: 24),

            // Defaults section
            _sectionHeader(l10n.defaultsSection),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: settings.defaultBand,
                    decoration:
                        InputDecoration(labelText: l10n.defaultBand),
                    items: kCommonBands
                        .map((b) =>
                            DropdownMenuItem(value: b, child: Text(b)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        ref
                            .read(settingsProvider.notifier)
                            .setDefaultBand(v);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: settings.defaultMode,
                    decoration:
                        InputDecoration(labelText: l10n.defaultMode),
                    items: kCommonModes
                        .map((m) =>
                            DropdownMenuItem(value: m, child: Text(m)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        ref
                            .read(settingsProvider.notifier)
                            .setDefaultMode(v);
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // App settings
            _sectionHeader(l10n.appSection),
            _ThemeCard(
              isDark: settings.darkTheme,
              onChanged: (v) =>
                  ref.read(settingsProvider.notifier).setDarkTheme(v),
            ),
            const SizedBox(height: 4),
            _NavStyleCard(
              useModern: settings.useModernNav,
              onChanged: (v) =>
                  ref.read(settingsProvider.notifier).setNavStyle(modern: v),
            ),
            const SizedBox(height: 4),
            SwitchListTile(
              title: Text(l10n.offlineMode),
              subtitle: Text(l10n.offlineModeHint),
              value: settings.offlineModeEnabled,
              onChanged: (v) =>
                  ref.read(settingsProvider.notifier).setOfflineMode(v),
            ),
            SwitchListTile(
              title: Text(l10n.potaAutoSpot),
              subtitle: Text(l10n.potaAutoSpotHint),
              secondary: const Icon(Icons.wifi_tethering),
              value: settings.potaAutoSpotEnabled,
              onChanged: (v) =>
                  ref.read(settingsProvider.notifier).setPotaAutoSpot(v),
            ),

            // Language picker
            DropdownButtonFormField<String?>(
              key: ValueKey(settings.locale),
              initialValue: settings.locale,
              decoration: InputDecoration(
                labelText: l10n.languageLabel,
                prefixIcon: const Icon(Icons.language),
              ),
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.langSystem)),
                DropdownMenuItem(value: 'en', child: Text(l10n.langEnglish)),
                DropdownMenuItem(value: 'tr', child: Text(l10n.langTurkish)),
                DropdownMenuItem(value: 'pl', child: Text(l10n.langPolish)),
                DropdownMenuItem(value: 'de', child: Text(l10n.langGerman)),
              ],
              onChanged: (v) =>
                  ref.read(settingsProvider.notifier).setLocale(v),
            ),

            const SizedBox(height: 24),

            // Danger zone
            _sectionHeader(l10n.dataSection),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: Text(l10n.clearCacheBtn),
              subtitle: Text(l10n.clearCacheHint),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(l10n.clearCacheTitle),
                    content: Text(l10n.clearCacheConfirm),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text(l10n.cancel)),
                      TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text(l10n.clearCacheAction,
                              style: const TextStyle(color: Colors.red))),
                    ],
                  ),
                );
                if (confirm == true && context.mounted) {
                  await ref.read(qsoCacheDatasourceProvider).clearCache();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.cacheCleared)),
                  );
                }
              },
            ),

            const SizedBox(height: 24),

            // About
            _sectionHeader(l10n.infoSection),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.aboutAppBtn),
              subtitle: Text(l10n.aboutAppHint),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/about'),
            ),

            const SizedBox(height: 40),

            Center(
              child: Text(
                () {
                  final version = ref.watch(packageInfoProvider).valueOrNull?.version;
                  return version != null ? '${l10n.appTitle} v$version' : l10n.appTitle;
                }(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

// ── Nav style card ────────────────────────────────────────────────────────────

class _NavStyleCard extends StatelessWidget {
  final bool useModern;
  final ValueChanged<bool> onChanged;

  const _NavStyleCard({required this.useModern, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(Icons.navigation_outlined, size: 20, color: cs.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.navStyleLabel,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    useModern
                        ? context.l10n.navStyleModern
                        : context.l10n.navStyleClassic,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: true,
                  icon: Icon(Icons.view_quilt_outlined, size: 18),
                ),
                ButtonSegment(
                  value: false,
                  icon: Icon(Icons.table_rows_outlined, size: 18),
                ),
              ],
              selected: {useModern},
              showSelectedIcon: false,
              onSelectionChanged: (s) => onChanged(s.first),
              style: const ButtonStyle(
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Theme toggle card ─────────────────────────────────────────────────────────

class _ThemeCard extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onChanged;

  const _ThemeCard({required this.isDark, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Icon + label
            Icon(
              isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              size: 20,
              color: cs.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.themeLabel,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isDark ? context.l10n.darkThemeActive : context.l10n.lightThemeActive,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Segmented button
            SegmentedButton<bool>(
              segments: [
                ButtonSegment(
                  value: false,
                  icon: const Icon(Icons.light_mode, size: 18),
                  label: Text(context.l10n.lightThemeLabel),
                ),
                ButtonSegment(
                  value: true,
                  icon: const Icon(Icons.dark_mode, size: 18),
                  label: Text(context.l10n.darkThemeLabel),
                ),
              ],
              selected: {isDark},
              showSelectedIcon: false,
              onSelectionChanged: (s) => onChanged(s.first),
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                textStyle: WidgetStateProperty.all(
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
