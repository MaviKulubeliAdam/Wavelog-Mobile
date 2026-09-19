import '../../data/models/qso_model.dart';
import '../../data/models/station_logbook_model.dart';
import '../../data/models/station_model.dart';

/// Station IDs the UI should currently show QSOs for, or null for "all".
///
/// Mirrors the Wavelog web behaviour: the active logbook wins and brings all
/// of its linked stations along; without one, only the active station counts.
/// The server's `active` flag is authoritative (it is what the web UI uses and
/// can change there at any time); the locally stored [logbookId] is only a
/// fallback for when the server flags none.
Set<int>? activeScopeStationIds({
  required int? logbookId,
  required int? stationId,
  required List<StationLogbookModel>? logbooks,
}) {
  if (logbooks != null) {
    final serverActive = logbooks
        .where((l) => l.active && l.stationIds.isNotEmpty)
        .firstOrNull;
    if (serverActive != null) return serverActive.stationIds.toSet();
    if (logbookId != null) {
      final lb = logbooks.where((l) => l.id == logbookId).firstOrNull;
      if (lb != null && lb.stationIds.isNotEmpty) return lb.stationIds.toSet();
    }
  }
  if (stationId != null) return {stationId};
  return null;
}

/// Station IDs whose QSOs count towards DXCC for the current [scopeIds].
///
/// DXCC awards belong to a callsign, not to a logbook: every station that
/// shares a callsign with the scoped stations contributes (e.g. all logbooks
/// of SP9AQG), while other callsigns of the same operator (e.g. TA4RX) do not.
/// Returns null ("everything") when there is no scope.
Set<int>? dxccStationIds(Set<int>? scopeIds, List<StationModel> stations) {
  if (scopeIds == null) return null;
  String norm(String c) => c.trim().toUpperCase();
  final calls = stations
      .where((s) => scopeIds.contains(s.id))
      .map((s) => norm(s.callsign))
      .where((c) => c.isNotEmpty)
      .toSet();
  if (calls.isEmpty) return scopeIds;
  return {
    ...scopeIds,
    ...stations.where((s) => calls.contains(norm(s.callsign))).map((s) => s.id),
  };
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
