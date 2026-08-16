import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/utils/error_l10n.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../data/models/detailed_statistics_model.dart';
import '../../../data/models/dxcc_entity_model.dart';
import '../../../data/models/pota_stats_model.dart';
import '../../../data/models/qso_model.dart';
import '../../../providers/detailed_statistics_provider.dart';
import '../../../providers/pota_stats_provider.dart';
import '../../../providers/remote_datasource_provider.dart';
import '../../../providers/qso_provider.dart';
import '../../../providers/solar_provider.dart';
import '../../../providers/statistics_provider.dart';
import '../../widgets/common/error_view.dart';
import '../propagation/propagation_screen.dart';

// ─── DXCC helpers ────────────────────────────────────────────────────────────

String _titleCase(String s) => s
    .split(' ')
    .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
    .join(' ');

/// Returns the first segment of a callsign (before any "/"), uppercased.
/// "G3ABC/P" → "G3ABC", "G/DL1ABC" → "G", "VK9X/VK4ABC" → "VK9X".
String _normalizeQsoCall(String raw) {
  if (raw.isEmpty) return '';
  return raw.toUpperCase().split('/').first.trim();
}

/// Finds the DXCC entity whose prefix is the longest match for [call].
/// [sorted] must be sorted by prefix.length descending.
DxccEntity? _matchDxccByCall(String call, List<DxccEntity> sorted) {
  for (final e in sorted) {
    if (call.startsWith(e.prefix.toUpperCase())) return e;
  }
  return null;
}

// Fallback continent derivation from CQ zone when the server omits the field.
// Zone 40 = Iceland / Faroe Is. (EU). Zone 21 = Canary Is. / Madeira (DXCC continent EU).
String _cqZoneToContinent(int cqz) {
  if (cqz >= 1  && cqz <= 8)  return 'NA';
  if (cqz >= 9  && cqz <= 13) return 'SA';
  if (cqz >= 14 && cqz <= 21) return 'EU';
  if (cqz >= 22 && cqz <= 27) return 'AF';
  if (cqz >= 28 && cqz <= 32) return 'AS';
  if (cqz >= 33 && cqz <= 38) return 'OC';
  if (cqz == 39)               return 'AN';
  if (cqz == 40)               return 'EU';
  return '?';
}

enum _DxccStatus { confirmed, pending, notWorked }

class _DxccEntry {
  final int adif;
  final String country;
  final String continent;
  final int count;
  final _DxccStatus status;

  const _DxccEntry({
    required this.adif,
    required this.country,
    required this.continent,
    required this.count,
    required this.status,
  });
}

class _DxccData {
  final int totalEntities;
  final int worked;
  final int confirmed;
  final int lotwConfirmed;
  final int eqslConfirmed;
  final int qslConfirmed;
  final int remaining;
  final List<_DxccEntry> entries;

  const _DxccData({
    required this.totalEntities,
    required this.worked,
    required this.confirmed,
    required this.lotwConfirmed,
    required this.eqslConfirmed,
    required this.qslConfirmed,
    required this.remaining,
    required this.entries,
  });
}

const _totalDxccEntities = 340;

final _dxccStatsProvider = FutureProvider<_DxccData>((ref) async {
  // Fetch server-side DXCC summary (worked/confirmed/available).
  // Used as fallback when local QSOs lack dxcc/country fields (v2 API).
  final serverStats = await ref.watch(statisticsProvider.future);

  final box = Hive.box<QsoModel>('qso_cache');

  // Build worked map from QSO cache: adif → confirmation status + continent
  final workedByAdif = <int, ({int count, bool lotw, bool eqsl, bool qsl, String cont})>{};
  // Fallback by country name (when dxcc field missing)
  final workedByName = <String, ({String cont, int count, bool lotw, bool eqsl, bool qsl})>{};

  for (final qso in box.values) {
    final lotwY = qso.lotwRcvd?.toUpperCase() == 'Y';
    final eqslY = qso.eqslRcvd?.toUpperCase() == 'Y';
    final qslY  = qso.qslRcvd?.toUpperCase()  == 'Y';

    final adif = int.tryParse(qso.dxcc?.trim() ?? '');
    if (adif != null && adif > 0) {
      final ex = workedByAdif[adif];
      workedByAdif[adif] = (
        count: (ex?.count ?? 0) + 1,
        lotw:  (ex?.lotw  ?? false) || lotwY,
        eqsl:  (ex?.eqsl  ?? false) || eqslY,
        qsl:   (ex?.qsl   ?? false) || qslY,
        cont:  qso.continent?.trim().toUpperCase() ?? ex?.cont ?? '',
      );
    }

    final name = _titleCase(qso.country?.trim() ?? '');
    if (name.isNotEmpty) {
      final ex = workedByName[name];
      workedByName[name] = (
        cont:  qso.continent?.trim() ?? ex?.cont ?? '',
        count: (ex?.count ?? 0) + 1,
        lotw:  (ex?.lotw  ?? false) || lotwY,
        eqsl:  (ex?.eqsl  ?? false) || eqslY,
        qsl:   (ex?.qsl   ?? false) || qslY,
      );
    }
  }

  // Try to fetch the full entity list from the Wavelog server (requires patch)
  List<DxccEntity> entities = [];
  try {
    entities = (await ref.read(wavelogRemoteDatasourceProvider).getDxccList())
        .where((e) => !e.deleted)
        .toList();
  } catch (_) {}

  // v2 API QSOs lack a `dxcc` field, so workedByAdif is empty after the first pass.
  // Derive DXCC entity from callsign prefix (longest-match against entity prefix list).
  if (entities.isNotEmpty && workedByAdif.isEmpty) {
    final sortedByPrefix = entities
        .where((e) => e.prefix.isNotEmpty && e.adif > 0)
        .toList()
        ..sort((a, b) => b.prefix.length.compareTo(a.prefix.length));

    for (final qso in box.values) {
      final call = _normalizeQsoCall(qso.callsign);
      if (call.isEmpty) continue;
      final entity = _matchDxccByCall(call, sortedByPrefix);
      if (entity == null) continue;

      final lotwY = qso.lotwRcvd?.toUpperCase() == 'Y';
      final eqslY = qso.eqslRcvd?.toUpperCase() == 'Y';
      final qslY  = qso.qslRcvd?.toUpperCase()  == 'Y';

      final ex = workedByAdif[entity.adif];
      workedByAdif[entity.adif] = (
        count: (ex?.count ?? 0) + 1,
        lotw:  (ex?.lotw  ?? false) || lotwY,
        eqsl:  (ex?.eqsl  ?? false) || eqslY,
        qsl:   (ex?.qsl   ?? false) || qslY,
        cont:  entity.continent,
      );
    }
  }

  List<_DxccEntry> allEntries;

  if (entities.isNotEmpty) {
    // Full-list mode: every DXCC entity gets an entry (confirmed / pending / not worked).
    // Skip deleted entities and the special "/mm /am" placeholder (ADIF 0 / name starts with '-').
    allEntries = entities
        .where((e) => !e.deleted && e.adif != 0 && !e.name.startsWith('-'))
        .map((entity) {
      final w = workedByAdif[entity.adif];
      final confirmed = w != null && (w.lotw || w.eqsl || w.qsl);
      final status = w == null
          ? _DxccStatus.notWorked
          : confirmed
              ? _DxccStatus.confirmed
              : _DxccStatus.pending;
      return _DxccEntry(
        adif:      entity.adif,
        country:   entity.name,
        continent: entity.continent.isNotEmpty
            ? entity.continent.toUpperCase()
            : workedByAdif[entity.adif]?.cont.isNotEmpty == true
                ? workedByAdif[entity.adif]!.cont
                : _cqZoneToContinent(entity.cqZone),
        count:     w?.count ?? 0,
        status:    status,
      );
    }).toList();
  } else {
    // Fallback: only worked countries (no patch / server unreachable)
    allEntries = workedByName.entries.map((e) {
      final w = e.value;
      final confirmed = w.lotw || w.eqsl || w.qsl;
      return _DxccEntry(
        adif:      0,
        country:   e.key,
        continent: w.cont.isNotEmpty ? w.cont.toUpperCase() : '?',
        count:     w.count,
        status:    confirmed ? _DxccStatus.confirmed : _DxccStatus.pending,
      );
    }).toList();
  }

  final localWorked    = allEntries.where((e) => e.status != _DxccStatus.notWorked).length;
  final localConfirmed = allEntries.where((e) => e.status == _DxccStatus.confirmed).length;
  final total          = entities.isNotEmpty ? entities.length : _totalDxccEntities;

  // Confirmation breakdown for summary card (still useful per-method)
  int lotwC = 0, eqslC = 0, qslC = 0;
  for (final w in workedByAdif.values) {
    if (w.lotw) lotwC++;
    if (w.eqsl) eqslC++;
    if (w.qsl)  qslC++;
  }
  if (entities.isEmpty) {
    for (final w in workedByName.values) {
      if (w.lotw) lotwC++;
      if (w.eqsl) eqslC++;
      if (w.qsl)  qslC++;
    }
  }

  // Summary card always shows server-authoritative counts.
  // Prefix-matched local counts power the per-entity breakdown but may differ slightly.
  final workedCount    = serverStats.dxccWorked > 0    ? serverStats.dxccWorked    : localWorked;
  final confirmedCount = serverStats.dxccConfirmed > 0 ? serverStats.dxccConfirmed : localConfirmed;
  final entityTotal    = serverStats.dxccAvailable > 0 ? serverStats.dxccAvailable : total;

  return _DxccData(
    totalEntities: entityTotal,
    worked:        workedCount,
    confirmed:     confirmedCount,
    lotwConfirmed: lotwC,
    eqslConfirmed: eqslC,
    qslConfirmed:  qslC,
    remaining:     (entityTotal - workedCount).clamp(0, entityTotal),
    entries:       allEntries,
  );
});

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
                ref.invalidate(_dxccStatsProvider);
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _StatsTab(),
            const PropagationScreen(),
            const _DxccTab(),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DXCC tab
// ─────────────────────────────────────────────────────────────────────────────

String _continentName(String code) => switch (code.toUpperCase()) {
      'EU' => 'Europe',
      'NA' => 'North America',
      'SA' => 'South America',
      'AF' => 'Africa',
      'AS' => 'Asia',
      'OC' => 'Oceania',
      'AN' => 'Antarctica',
      '?'  => 'Other',
      _    => code,
    };

const _continentOrder = ['EU', 'NA', 'SA', 'AF', 'AS', 'OC', 'AN', '?'];

class _DxccTab extends ConsumerWidget {
  const _DxccTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final async = ref.watch(_dxccStatsProvider);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return async.when(
      data: (data) {
        if (data.worked == 0 && data.entries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.flag_outlined, size: 64,
                    color: cs.onSurface.withValues(alpha: 0.3)),
                const SizedBox(height: 16),
                Text(l10n.noQsos,
                    style: tt.bodyMedium
                        ?.copyWith(color: cs.onSurface.withValues(alpha: 0.5))),
              ],
            ),
          );
        }

        // Group by continent, sort within each group
        final byContinent = <String, List<_DxccEntry>>{};
        for (final e in data.entries) {
          (byContinent[e.continent.isNotEmpty ? e.continent : '?'] ??= []).add(e);
        }
        for (final list in byContinent.values) {
          list.sort((a, b) {
            final s = a.status.index.compareTo(b.status.index);
            return s != 0 ? s : a.country.compareTo(b.country);
          });
        }
        final continents = byContinent.keys.toList()
          ..sort((a, b) {
            final ia = _continentOrder.indexOf(a.toUpperCase());
            final ib = _continentOrder.indexOf(b.toUpperCase());
            if (ia == -1 && ib == -1) return a.compareTo(b);
            if (ia == -1) return 1;
            if (ib == -1) return -1;
            return ia.compareTo(ib);
          });

        return ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
          children: [
            // ── Summary card ──────────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.dxccProgress,
                        style: tt.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _DxccSummaryRow(
                      label: l10n.workedCountries,
                      value: '${data.worked} / ${data.totalEntities}',
                      color: cs.primary,
                    ),
                    const Divider(height: 20),
                    _DxccSummaryRow(
                      label: l10n.dxccConfirmed,
                      value:
                          '${data.lotwConfirmed} / ${data.eqslConfirmed} / ${data.qslConfirmed}',
                      color: Colors.green,
                    ),
                    const Divider(height: 20),
                    _DxccSummaryRow(
                      label: l10n.dxccRemaining,
                      value: '${data.remaining}',
                      color: cs.onSurfaceVariant,
                    ),
                    const SizedBox(height: 14),
                    // Legend
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _LegendDot(Icons.check_circle,   Colors.green,  l10n.dxccLegendConfirmed),
                        const SizedBox(width: 14),
                        _LegendDot(Icons.hourglass_empty, Colors.amber, l10n.dxccLegendPending),
                        const SizedBox(width: 14),
                        _LegendDot(Icons.cancel,          Colors.red,   l10n.dxccLegendNotWorked),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // ── Continent groups (ExpansionTile) ──────────────────────
            for (final cont in continents)
              _ContinentTile(
                code:    cont,
                entries: byContinent[cont]!,
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => ErrorView(
        message: localizeError(context, e),
        onRetry: () => ref.invalidate(_dxccStatsProvider),
      ),
    );
  }
}

// ── Continent ExpansionTile ───────────────────────────────────────────────────

class _ContinentTile extends StatelessWidget {
  final String code;
  final List<_DxccEntry> entries;

  const _ContinentTile({required this.code, required this.entries});

  @override
  Widget build(BuildContext context) {
    final cs  = Theme.of(context).colorScheme;
    final tt  = Theme.of(context).textTheme;

    final confirmed  = entries.where((e) => e.status == _DxccStatus.confirmed).length;
    final pending    = entries.where((e) => e.status == _DxccStatus.pending).length;
    final worked     = confirmed + pending;
    final total      = entries.length;

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
          _continentName(code),
          style: tt.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '$worked / $total  ·  ✓ $confirmed',
          style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
        ),
        children: [
          const Divider(height: 1),
          ...entries.asMap().entries.map((entry) {
            final i = entry.key;
            final e = entry.value;
            return Column(
              children: [
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  leading: _statusIcon(e.status),
                  title: Text(
                    e.country,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: e.status == _DxccStatus.notWorked
                          ? cs.onSurface.withValues(alpha: 0.45)
                          : null,
                    ),
                  ),
                  trailing: e.count > 0
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: cs.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${e.count}',
                            style: tt.labelMedium?.copyWith(
                                color: cs.onPrimaryContainer,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : null,
                ),
                if (i < entries.length - 1) const Divider(height: 1),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _statusIcon(_DxccStatus status) => switch (status) {
        _DxccStatus.confirmed  => const Icon(Icons.check_circle,
            color: Colors.green, size: 18),
        _DxccStatus.pending    => const Icon(Icons.hourglass_empty,
            color: Colors.amber, size: 18),
        _DxccStatus.notWorked  => Icon(Icons.cancel,
            color: Colors.red.shade300, size: 18),
      };
}

// ── Legend dot ────────────────────────────────────────────────────────────────

class _LegendDot extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  const _LegendDot(this.icon, this.color, this.label);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ],
      );
}

// ── Summary row ───────────────────────────────────────────────────────────────

class _DxccSummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _DxccSummaryRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: tt.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant)),
        Text(value,
            style: tt.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold, color: color)),
      ],
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
          _SectionHeader(l10n.statsTotal),
          const SizedBox(height: 6),
          Row(
            children: [
              _StatCard(l10n.statsToday, data.todayQsos.toString(), Icons.today),
              _StatCard(l10n.statsMonth, data.monthQsos.toString(), Icons.calendar_month),
              _StatCard(l10n.statsYear, data.yearQsos.toString(), Icons.calendar_today),
              _StatCard(l10n.statsTotal, data.totalQsos.toString(), Icons.storage),
            ].map((w) => Expanded(child: w)).toList(),
          ),
          const SizedBox(height: 16),

          // ── Highlights ────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _HighlightCard(
                  icon: Icons.people_outline,
                  value: data.uniqueCallsigns.toString(),
                  label: l10n.uniqueCallsigns,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _HighlightCard(
                  icon: Icons.local_fire_department_outlined,
                  value: l10n.streakDays(data.currentStreakDays),
                  label: l10n.currentStreak,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Per station ───────────────────────────────────────────
          if (data.qsosByStation.isNotEmpty) ...[
            _SectionHeader(l10n.perStation),
            const SizedBox(height: 6),
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
            _SectionHeader(l10n.bandDistribution),
            const SizedBox(height: 6),
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
            _SectionHeader(l10n.modeDistribution),
            const SizedBox(height: 6),
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

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
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
      margin: const EdgeInsets.all(3),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Column(
          children: [
            Icon(icon, size: 18, color: theme.colorScheme.primary),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HighlightCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _HighlightCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                  Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
              child: _HighlightCard(
                icon: Icons.contacts_outlined,
                value: stats.totalQsos.toString(),
                label: l10n.potaTotalQsos,
                color: potaGreen,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _HighlightCard(
                icon: Icons.flag_outlined,
                value: stats.activatedCount.toString(),
                label: l10n.potaActivatedParks,
                color: potaGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ── Park list ─────────────────────────────────────────────────
        _SectionHeader(l10n.potaAllParks),
        const SizedBox(height: 6),
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
