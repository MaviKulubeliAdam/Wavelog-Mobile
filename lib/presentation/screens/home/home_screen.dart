import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/utils/error_l10n.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../providers/qso_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/statistics_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/common/offline_banner.dart';
import '../../widgets/qso/qso_list_tile.dart';
import '../../widgets/qso/qso_skeleton_list.dart';
import '../../../router.dart';
import '../../../providers/contest_calendar_provider.dart';
import '../../../data/models/contest_event_model.dart';
import 'package:intl/intl.dart';

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
        leading: const DrawerMenuButton(),
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
          // Classic modda drawer yok — ADIF ve Settings butonları görünür
          if (!settings.useModernNav) ...[
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
        ],
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(child: _HomeBody(
            statistics: statistics,
            recentQsos: recentQsos,
            localTodayQsos: localTodayQsos,
            settings: settings,
          )),
        ],
      ),
    );
  }
}

// ── Home Body — tablet landscape aware ───────────────────────────────────────

class _HomeBody extends ConsumerWidget {
  final AsyncValue<dynamic> statistics;
  final AsyncValue<dynamic> recentQsos;
  final int localTodayQsos;
  final dynamic settings;

  const _HomeBody({
    required this.statistics,
    required this.recentQsos,
    required this.localTodayQsos,
    required this.settings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isTabletLandscape = size.width > 720 && size.width > size.height;

    Future<void> onRefresh() async {
      ref.invalidate(qsoProvider);
      ref.invalidate(statisticsProvider);
      ref.invalidate(recentQsoProvider);
      ref.invalidate(logbookSummaryProvider);
      ref.invalidate(contestCalendarProvider);
    }

    if (isTabletLandscape) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left — recent QSOs
          Expanded(
            flex: 3,
            child: RefreshIndicator(
              color: kAccentElectric,
              backgroundColor: Theme.of(context).colorScheme.surface,
              onRefresh: onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: _QsoPanel(
                  statistics: statistics,
                  recentQsos: recentQsos,
                  localTodayQsos: localTodayQsos,
                  settings: settings,
                ),
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          // Right — contest card
          SizedBox(
            width: 340,
            child: RefreshIndicator(
              color: kAccentElectric,
              backgroundColor: Theme.of(context).colorScheme.surface,
              onRefresh: onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                child: const _ContestCard(),
              ),
            ),
          ),
        ],
      );
    }

    // Portrait / phone layout
    return RefreshIndicator(
      color: kAccentElectric,
      backgroundColor: Theme.of(context).colorScheme.surface,
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const _ContestCard(),
          const SizedBox(height: 8),
          _QsoPanel(
            statistics: statistics,
            recentQsos: recentQsos,
            localTodayQsos: localTodayQsos,
            settings: settings,
          ),
        ],
      ),
    );
  }
}

// ── QSO panel — stats + no-station warning + recent QSOs ─────────────────────

class _QsoPanel extends StatelessWidget {
  final AsyncValue<dynamic> statistics;
  final AsyncValue<dynamic> recentQsos;
  final int localTodayQsos;
  final dynamic settings;

  const _QsoPanel({
    required this.statistics,
    required this.recentQsos,
    required this.localTodayQsos,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (statistics.hasValue)
          _StatsRow(stats: statistics.value!, localTodayQsos: localTodayQsos)
        else if (statistics.isLoading)
          const Padding(
            padding: EdgeInsets.all(16),
            child: LinearProgressIndicator(),
          )
        else if (statistics.hasError)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text('${l10n.error}: ${localizeError(context, statistics.error!)}',
                style: Theme.of(context).textTheme.bodySmall),
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
                onPressed: () => GoRouter.of(context).push('/stations'),
                child: Text(l10n.change),
              ),
            ),
          ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(l10n.recentQsos, style: Theme.of(context).textTheme.titleMedium),
        ),
        recentQsos.when(
          data: (qsos) {
            if (qsos.isEmpty) {
              return EmptyView(message: l10n.noRecentQsos, icon: Icons.radio_outlined);
            }
            return Column(
              children: qsos
                  .map<Widget>((q) => QsoListTile(
                        qso: q,
                        onTap: () => GoRouter.of(context)
                            .push('/qsos/${Uri.encodeComponent(q.localId ?? '')}'),
                      ))
                  .toList(),
            );
          },
          loading: () => const QsoSkeletonList(count: 6),
          error: (e, _) => ErrorView(
            message: localizeError(context, e),
            onRetry: () {},
          ),
        ),
        recentQsos.when(
          data: (qsos) => qsos.isNotEmpty
              ? TextButton(
                  onPressed: () => GoRouter.of(context).push('/qsos'),
                  child: Text('${l10n.filterAll} QSO →'),
                )
              : const SizedBox.shrink(),
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

// ── Contest card ──────────────────────────────────────────────────────────────

class _ContestCard extends ConsumerWidget {
  const _ContestCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final contests = ref.watch(contestCalendarProvider);

    return Card(
      margin: EdgeInsets.zero,
      child: contests.when(
        loading: () => Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.calendar_month_outlined, color: cs.primary, size: 20),
              const SizedBox(width: 10),
              Text(context.l10n.upcomingContestsTitle,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      )),
              const Spacer(),
              const SizedBox(
                  width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
            ],
          ),
        ),
        error: (_, __) => ListTile(
          leading: Icon(Icons.calendar_month_outlined, color: cs.primary),
          title: Text(context.l10n.contestCalendarTitle),
          subtitle: Text(context.l10n.viewAll),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => GoRouter.of(context).push('/calendar'),
        ),
        data: (events) {
          final active = events
              .where((e) => e.isToday && !e.isPast)
              .toList();
          final upcoming = events
              .where((e) => !e.isToday && !e.isPast)
              .take(4)
              .toList();
          final all = [...active, ...upcoming];

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 8, 4),
                child: Row(
                  children: [
                    Icon(Icons.calendar_month_outlined, color: cs.primary, size: 18),
                    const SizedBox(width: 8),
                    Text(context.l10n.upcomingContestsTitle,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: cs.primary,
                            )),
                    const Spacer(),
                    TextButton(
                      style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero),
                      onPressed: () => GoRouter.of(context).push('/calendar'),
                      child: Text(context.l10n.viewAll),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              if (all.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(context.l10n.noUpcomingContests),
                )
              else
                ...all.map((e) => _ContestRow(event: e)),
              const SizedBox(height: 4),
            ],
          );
        },
      ),
    );
  }
}

class _ContestRow extends StatelessWidget {
  final ContestEvent event;
  const _ContestRow({required this.event});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isToday = event.isToday;
    final dateStr = event.startUtc != null
        ? DateFormat('MMM d').format(event.startUtc!)
        : '';
    final timeStr = event.startUtc != null
        ? DateFormat('HHmm\'Z\'').format(event.startUtc!)
        : '';

    return InkWell(
      onTap: event.link.isNotEmpty
          ? () => launchUrl(Uri.parse(event.link), mode: LaunchMode.externalApplication)
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        child: Row(
          children: [
            // Today badge or date
            Container(
              width: 44,
              alignment: Alignment.center,
              child: isToday
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: cs.error,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(context.l10n.contestTodayBadge,
                          style: TextStyle(
                              color: cs.onError,
                              fontSize: 8,
                              fontWeight: FontWeight.bold)),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(dateStr,
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: cs.primary)),
                        if (timeStr.isNotEmpty)
                          Text(timeStr,
                              style: TextStyle(fontSize: 8, color: cs.onSurfaceVariant)),
                      ],
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                event.title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (event.link.isNotEmpty)
              Icon(Icons.open_in_new, size: 12, color: cs.onSurfaceVariant.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}

// ── Stats row ─────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final dynamic stats;
  final int localTodayQsos;
  const _StatsRow({required this.stats, required this.localTodayQsos});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Local Hive count is always accurate (updates immediately on add/delete).
    // Server todayQsos can lag due to caching, so never trust it over local.
    final todayCount = localTodayQsos;
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

