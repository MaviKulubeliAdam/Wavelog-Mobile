class StatisticsModel {
  final int todayQsos;
  final int monthQsos;
  final int yearQsos;
  final int totalQsos;

  const StatisticsModel({
    this.todayQsos = 0,
    this.monthQsos = 0,
    this.yearQsos = 0,
    this.totalQsos = 0,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      todayQsos: _parseInt(json['Today'] ?? json['today_qsos'] ?? json['todayqsos']),
      monthQsos: _parseInt(json['month_qsos'] ?? json['monthqsos']),
      yearQsos: _parseInt(json['year_qsos'] ?? json['yearqsos']),
      totalQsos: _parseInt(json['total_qsos'] ?? json['totalqsos'] ?? json['total']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}
