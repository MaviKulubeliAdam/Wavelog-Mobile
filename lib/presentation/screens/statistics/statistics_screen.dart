import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/error_l10n.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../data/models/detailed_statistics_model.dart';
import '../../../data/models/pota_stats_model.dart';
import '../../../providers/detailed_statistics_provider.dart';
import '../../../providers/pota_stats_provider.dart';
import '../../../providers/qso_provider.dart';
import '../../../providers/solar_provider.dart';
import '../../../providers/statistics_provider.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/common/stat_card.dart';
import '../propagation/propagation_screen.dart';
import 'dxcc_tab.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.statisticsTitle),
          bottom: TabBar(
            tabs: [
              Tab(icon: const Icon(Icons.bar_chart), text: l10n.statsTab),
              Tab(
                  icon: const Icon(Icons.wifi_tethering),
                  text: l10n.propagationTab),
              const Tab(icon: Icon(Icons.flag_outlined), text: 'DXCC'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.map_outlined),
              tooltip: l10n.mapTitle,
              onPressed: () => context.push('/map'),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref.invalidate(qsoProvider);
                ref.invalidate(statisticsProvider);
                ref.invalidate(detailedStatisticsProvider);
                ref.invalidate(solarDataProvider);
                ref.invalidate(potaStatsProvider);
                ref.invalidate(dxccStatsProvider);
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _StatsTab(),
            const PropagationScreen(),
            const DxccTab(),
          ],
        ),
      ),
    );
  }
}

class _StatsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(detailedStatisticsProvider);

    return stats.when(
      data: (data) => _StatisticsBody(
        data: data,
        onRefresh: () async {
          ref.invalidate(statisticsProvider);
          ref.invalidate(detailedStatisticsProvider);
          ref.invalidate(potaStatsProvider);
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => ErrorView(
        message: localizeError(context, e),
        onRetry: () {
          ref.invalidate(statisticsProvider);
          ref.invalidate(detailedStatisticsProvider);
        },
      ),
    );
  }
}

class _StatisticsBody extends StatelessWidget {
  final DetailedStatisticsModel data;
  final Future<void> Function() onRefresh;
  const _StatisticsBody({required this.data, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // ── Time-based totals ─────────────────────────────────────
          SectionHeader(label: l10n.statsTotal),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  value: data.todayQsos.toString(),
                  label: l10n.statsToday,
                  icon: Icons.today,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StatCard(
                  value: data.monthQsos.toString(),
                  label: l10n.statsMonth,
                  icon: Icons.calendar_month,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StatCard(
                  value: data.yearQsos.toString(),
                  label: l10n.statsYear,
                  icon: Icons.calendar_today,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StatCard(
                  value: data.totalQsos.toString(),
                  label: l10n.statsTotal,
                  icon: Icons.storage,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Highlights ────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.people_outline,
                  value: data.uniqueCallsigns.toString(),
                  label: l10n.uniqueCallsigns,
                  accentColor: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StatCard(
                  icon: Icons.local_fire_department_outlined,
                  value: l10n.streakDays(data.currentStreakDays),
                  label: l10n.currentStreak,
                  accentColor: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Per station ───────────────────────────────────────────
          if (data.qsosByStation.isNotEmpty) ...[
            SectionHeader(label: l10n.perStation),
            Card(
              child: Column(
                children: data.qsosByStation.asMap().entries.map((entry) {
                  final i = entry.key;
                  final s = entry.value;
                  final isLast = i == data.qsosByStation.length - 1;
                  return Column(
                    children: [
                      ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primaryContainer,
                          child: Text(
                            '${i + 1}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                          ),
                        ),
                        title: Text(s.callsign,
                            style: const TextStyle(
                                fontFamily: kMonoFontFamily,
                                fontWeight: FontWeight.w600)),
                        subtitle: Text(s.name,
                            style: const TextStyle(fontSize: 12)),
                        trailing: _CountBadge(s.count),
                      ),
                      if (!isLast) const Divider(height: 1),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // ── Band distribution ─────────────────────────────────────
          if (data.qsosByBand.isNotEmpty) ...[
            SectionHeader(label: l10n.bandDistribution),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: Column(
                  children: _buildBars(
                      context, data.qsosByBand),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // ── Mode distribution ─────────────────────────────────────
          if (data.qsosByMode.isNotEmpty) ...[
            SectionHeader(label: l10n.modeDistribution),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: Column(
                  children: _buildBars(
                      context, data.qsosByMode),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // ── POTA stats ────────────────────────────────────────────
          const _PotaSection(),
          const SizedBox(height: 8),

          // ── Cache note ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              l10n.basedOnCache,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.45),
                  ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<Widget> _buildBars(
      BuildContext context, List<MapEntry<String, int>> entries) {
    if (entries.isEmpty) return [];
    final max = entries.first.value;
    final colorScheme = Theme.of(context).colorScheme;

    return entries.map((e) {
      final fraction = max > 0 ? e.value / max : 0.0;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(
              width: 52,
              child: Text(
                e.key,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: fraction,
                  minHeight: 14,
                  backgroundColor:
                      colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      colorScheme.primary),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 36,
              child: Text(
                '${e.value}',
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

class _CountBadge extends StatelessWidget {
  final int count;
  const _CountBadge(this.count);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// POTA Section
// ─────────────────────────────────────────────────────────────────────────────

class _PotaSection extends ConsumerWidget {
  const _PotaSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pota = ref.watch(potaStatsProvider);

    return pota.when(
      data: (stats) {
        if (stats == null || stats.parks.isEmpty) return const SizedBox.shrink();
        return _PotaContent(stats: stats);
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _PotaContent extends StatelessWidget {
  final PotaStats stats;
  const _PotaContent({required this.stats});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    const potaGreen = Color(0xFF2E7D32);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ──────────────────────────────────────────────────
        Row(
          children: [
            const Icon(Icons.park_outlined, size: 16, color: potaGreen),
            const SizedBox(width: 6),
            Text(
              l10n.potaStats,
              style: theme.textTheme.titleSmall?.copyWith(
                color: potaGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // ── Summary cards ────────────────────────────────────────────
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.contacts_outlined,
                value: stats.totalQsos.toString(),
                label: l10n.potaTotalQsos,
                accentColor: potaGreen,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: StatCard(
                icon: Icons.flag_outlined,
                value: stats.activatedCount.toString(),
                label: l10n.potaActivatedParks,
                accentColor: potaGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ── Park list ─────────────────────────────────────────────────
        SectionHeader(label: l10n.potaAllParks),
        Card(
          child: Column(
            children: stats.parks.asMap().entries.map((entry) {
              final i = entry.key;
              final park = entry.value;
              final isLast = i == stats.parks.length - 1;
              return Column(
                children: [
                  ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      radius: 16,
                      backgroundColor: park.isActivated
                          ? potaGreen.withValues(alpha: 0.15)
                          : theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.park_outlined,
                        size: 16,
                        color: park.isActivated
                            ? potaGreen
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    title: Text(
                      park.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${park.reference}  •  ${park.locationDesc}',
                      style: theme.textTheme.bodySmall,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _CountBadge(park.qsoCount),
                        const SizedBox(width: 6),
                        _StatusBadge(
                          label: park.isActivated
                              ? l10n.potaActivatedBadge
                              : l10n.potaAttemptBadge,
                          color: park.isActivated ? potaGreen : Colors.orange,
                        ),
                      ],
                    ),
                  ),
                  if (!isLast) const Divider(height: 1),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
