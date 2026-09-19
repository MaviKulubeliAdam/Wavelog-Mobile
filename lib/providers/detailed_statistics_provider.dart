import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/utils/qso_scope.dart';
import '../data/datasources/local/qso_cache_datasource.dart';
import '../data/models/detailed_statistics_model.dart';
import 'qso_provider.dart'; // logbookSummaryProvider + scope live here
import 'remote_datasource_provider.dart';
import 'station_provider.dart';

final detailedStatisticsProvider =
    FutureProvider<DetailedStatisticsModel>((ref) async {
  // Watching logbookSummaryProvider (not qsoProvider) ensures we re-run
  // AFTER Hive is updated. All QSO operations (add/edit/delete) invalidate
  // logbookSummaryProvider only after the Hive write completes, so the cache
  // read below always sees consistent data.
  await ref.watch(logbookSummaryProvider.future);

  // Everything is computed from the QSOs in the active scope (logbook first,
  // then active station) — the server statistic endpoint can't filter by
  // station or logbook, so its instance-wide totals would mix callsigns.
  final scopeIds = ref.watch(scopeStationIdsProvider);
  final cache = ref.read(qsoCacheDatasourceProvider);
  final scoped = filterByStations(await cache.getCachedQsos(), scopeIds);
  final counts = countQsos(scoped);
  final cacheStats = QsoCacheDatasource.computeStatsFor(scoped);

  // Map per-station counts to station names
  final stations = await ref.read(stationProvider.future);
  final qsosByStation = stations
      .map((s) => StationQsoCount(
            stationId: s.id,
            callsign: s.callsign,
            name: s.profileName,
            count: cacheStats.byStation[s.id] ?? 0,
          ))
      .where((s) => s.count > 0)
      .toList()
    ..sort((a, b) => b.count.compareTo(a.count));

  final qsosByBand = cacheStats.byBand.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  final qsosByMode = cacheStats.byMode.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  return DetailedStatisticsModel(
    totalQsos: counts.totalQsos,
    yearQsos: counts.yearQsos,
    monthQsos: counts.monthQsos,
    todayQsos: counts.todayQsos,
    uniqueCallsigns: cacheStats.uniqueCallsigns,
    currentStreakDays: cacheStats.currentStreakDays,
    qsosByBand: qsosByBand,
    qsosByMode: qsosByMode,
    qsosByStation: qsosByStation,
  );
});
