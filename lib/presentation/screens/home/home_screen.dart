import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/utils/error_l10n.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../providers/patch_status_provider.dart';
import '../../../providers/qso_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/statistics_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/common/offline_banner.dart';
import '../../widgets/qso/qso_list_tile.dart';
import '../../widgets/qso/qso_skeleton_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPatch();
      // Trigger initial QSO fetch so home screen data populates on first launch.
      ref.read(qsoProvider);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(qsoProvider);
    }
  }

  Future<void> _checkPatch() async {
    final installed = await ref.read(patchStatusProvider.future);
    if (installed || !mounted) return;

    final l10n = context.l10n;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange),
          const SizedBox(width: 8),
          Text(l10n.patchRequiredTitle),
        ]),
        content: Text(l10n.patchRequiredMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.close),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              launchUrl(
                Uri.parse('https://sp9aqg.pl/install.html'),
                mode: LaunchMode.externalApplication,
              );
            },
            icon: const Icon(Icons.open_in_browser, size: 16),
            label: Text(l10n.patchViewGuide),
          ),
        ],
      ),
    );
  }

  void _showQsoTypeSheet(BuildContext context) {
    final l10n = context.l10n;
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Text(l10n.qsoTypeTitle,
                    style: Theme.of(ctx).textTheme.titleMedium),
              ),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.radio)),
                title: Text(l10n.normalQso),
                subtitle: Text(l10n.normalQsoDesc),
                onTap: () {
                  Navigator.of(ctx).pop();
                  context.push('/add-qso');
                },
              ),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.emoji_events)),
                title: Text(l10n.contestQso),
                subtitle: Text(l10n.contestQsoDesc),
                onTap: () {
                  Navigator.of(ctx).pop();
                  context.push('/contest');
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider);
    final statistics = ref.watch(statisticsProvider);
    final recentQsos = ref.watch(recentQsoProvider);
    // Yerel "bugün" sayısı — computeStats() her build'de tüm Hive
    // kutusunu tarıyordu; logbookSummaryProvider zaten bunu hesaplıyor.
    final localTodayQsos =
        ref.watch(logbookSummaryProvider).valueOrNull?.todayCount ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          if (settings.activeStationCallsign != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ActionChip(
                avatar: const Icon(Icons.cell_tower, size: 16),
                label: Text(settings.activeStationCallsign!),
                onPressed: () => context.push('/stations'),
              ),
            ),
          IconButton(
            icon: Icon(
              settings.darkTheme
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            tooltip: settings.darkTheme ? l10n.switchToLightTheme : l10n.switchToDarkTheme,
            onPressed: () => ref
                .read(settingsProvider.notifier)
                .setDarkTheme(!settings.darkTheme),
          ),
          IconButton(
            icon: const Icon(Icons.swap_vert),
            tooltip: l10n.adifTitle,
            onPressed: () => context.push('/adif'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: RefreshIndicator(
              color: kAccentElectric,
              backgroundColor: Theme.of(context).colorScheme.surface,
              onRefresh: () async {
                ref.invalidate(statisticsProvider);
                ref.invalidate(recentQsoProvider);
                ref.invalidate(logbookSummaryProvider);
              },
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  statistics.when(
                    data: (stats) => _StatsRow(stats: stats, localTodayQsos: localTodayQsos),
                    loading: () => const Padding(
                      padding: EdgeInsets.all(16),
                      child: LinearProgressIndicator(),
                    ),
                    error: (e, _) => Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('${l10n.error}: ${localizeError(context, e)}',
                          style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ),

                  const SizedBox(height: 8),

                  if (settings.activeStationProfileId == null)
                    Card(
                      color: Theme.of(context).colorScheme.errorContainer,
                      child: ListTile(
                        leading: const Icon(Icons.warning_amber),
                        title: Text(l10n.noActiveStation),
                        subtitle: Text(l10n.selectStationBtn),
                        trailing: TextButton(
                          onPressed: () => context.push('/stations'),
                          child: Text(l10n.change),
                        ),
                      ),
                    ),

                  const SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    child: Text(l10n.recentQsos,
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  recentQsos.when(
                    data: (qsos) {
                      if (qsos.isEmpty) {
                        return EmptyView(
                          message: l10n.noRecentQsos,
                          icon: Icons.radio_outlined,
                        );
                      }
                      return Column(
                        children: qsos
                            .map((q) => QsoListTile(
                                  qso: q,
                                  onTap: () => context.push(
                                      '/qsos/${Uri.encodeComponent(q.localId ?? '')}'),
                                ))
                            .toList(),
                      );
                    },
                    loading: () => const QsoSkeletonList(count: 6),
                    error: (e, _) => ErrorView(
                      message: e.toString(),
                      onRetry: () => ref.invalidate(recentQsoProvider),
                    ),
                  ),

                  recentQsos.when(
                    data: (qsos) => qsos.isNotEmpty
                        ? TextButton(
                            onPressed: () => context.push('/qsos'),
                            child: Text('${l10n.filterAll} QSO →'),
                          )
                        : const SizedBox.shrink(),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showQsoTypeSheet(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.addQso,
            style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final dynamic stats;
  final int localTodayQsos;
  const _StatsRow({required this.stats, required this.localTodayQsos});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final todayCount = (stats.todayQsos as int) > 0
        ? stats.todayQsos as int
        : localTodayQsos;
    return Row(
      children: [
        _StatCard(l10n.statsToday, todayCount.toString(), Icons.today),
        _StatCard(l10n.statsMonth, stats.monthQsos.toString(), Icons.calendar_month),
        _StatCard(l10n.statsYear, stats.yearQsos.toString(), Icons.calendar_today),
        _StatCard(l10n.statsTotal, stats.totalQsos.toString(), Icons.storage),
      ].map((w) => Expanded(child: w)).toList(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard(this.label, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.all(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Column(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
            Text(label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.secondary,
                )),
          ],
        ),
      ),
    );
  }
}

