import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/detailed_statistics_model.dart';
import 'remote_datasource_provider.dart';
import 'station_provider.dart';
import 'statistics_provider.dart';

final detailedStatisticsProvider =
    FutureProvider<DetailedStatisticsModel>((ref) async {
  // Server-side totals (today/month/year/total)
  final serverStats = await ref.watch(statisticsProvider.future);

  // Local cache stats (band/mode/station/streak/unique callsigns)
  final cache = ref.read(qsoCacheDatasourceProvider);
  final cacheStats = cache.computeStats();

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
    totalQsos: serverStats.totalQsos,
    yearQsos: serverStats.yearQsos,
    monthQsos: serverStats.monthQsos,
    todayQsos: serverStats.todayQsos > 0 ? serverStats.todayQsos : cacheStats.todayQsos,
    uniqueCallsigns: cacheStats.uniqueCallsigns,
    currentStreakDays: cacheStats.currentStreakDays,
    qsosByBand: qsosByBand,
    qsosByMode: qsosByMode,
    qsosByStation: qsosByStation,
  );
});
