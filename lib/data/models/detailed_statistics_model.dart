class StationQsoCount {
  final int stationId;
  final String callsign;
  final String name;
  final int count;

  const StationQsoCount({
    required this.stationId,
    required this.callsign,
    required this.name,
    required this.count,
  });
}

class DetailedStatisticsModel {
  final int totalQsos;
  final int yearQsos;
  final int monthQsos;
  final int todayQsos;
  final int uniqueCallsigns;
  final int currentStreakDays;
  final List<MapEntry<String, int>> qsosByBand;
  final List<MapEntry<String, int>> qsosByMode;
  final List<StationQsoCount> qsosByStation;

  const DetailedStatisticsModel({
    required this.totalQsos,
    required this.yearQsos,
    required this.monthQsos,
    required this.todayQsos,
    required this.uniqueCallsigns,
    required this.currentStreakDays,
    required this.qsosByBand,
    required this.qsosByMode,
    required this.qsosByStation,
  });
}
