import '../../data/models/qso_model.dart';
import '../../data/models/station_logbook_model.dart';

/// Station IDs the UI should currently show QSOs for, or null for "all".
///
/// Mirrors the Wavelog web behaviour: an active logbook wins and brings all
/// of its linked stations along; without one, only the active station counts.
Set<int>? activeScopeStationIds({
  required int? logbookId,
  required int? stationId,
  required List<StationLogbookModel>? logbooks,
}) {
  if (logbookId != null && logbooks != null) {
    final lb = logbooks.where((l) => l.id == logbookId).firstOrNull;
    if (lb != null && lb.stationIds.isNotEmpty) return lb.stationIds.toSet();
  }
  if (stationId != null) return {stationId};
  return null;
}

List<QsoModel> filterByStations(List<QsoModel> qsos, Set<int>? stationIds) =>
    stationIds == null
        ? qsos
        : qsos.where((q) => stationIds.contains(q.stationProfileId)).toList();

class QsoCounts {
  final int todayQsos;
  final int monthQsos;
  final int yearQsos;
  final int totalQsos;

  const QsoCounts({
    required this.todayQsos,
    required this.monthQsos,
    required this.yearQsos,
    required this.totalQsos,
  });
}

QsoCounts countQsos(List<QsoModel> qsos) {
  final now = DateTime.now();
  var today = 0, month = 0, year = 0;
  for (final q in qsos) {
    final d = q.dateTimeOn.toLocal();
    if (d.year != now.year) continue;
    year++;
    if (d.month != now.month) continue;
    month++;
    if (d.day == now.day) today++;
  }
  return QsoCounts(
    todayQsos: today,
    monthQsos: month,
    yearQsos: year,
    totalQsos: qsos.length,
  );
}
