class StatisticsModel {
  final int todayQsos;
  final int monthQsos;
  final int yearQsos;
  final int totalQsos;
  final int dxccWorked;
  final int dxccConfirmed;
  final int dxccAvailable;

  const StatisticsModel({
    this.todayQsos = 0,
    this.monthQsos = 0,
    this.yearQsos = 0,
    this.totalQsos = 0,
    this.dxccWorked = 0,
    this.dxccConfirmed = 0,
    this.dxccAvailable = 0,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    // v2 response: { "qso": { "total": N, "activity": { "today": N, ... }, "dxcc": { "worked": N, "confirmed": N, "available": N } } }
    // legacy flat:  { "total_qsos": N, "today_qsos": N, ... }
    final qso = json['qso'] is Map<String, dynamic>
        ? json['qso'] as Map<String, dynamic>
        : null;
    final activity = qso?['activity'] is Map<String, dynamic>
        ? qso!['activity'] as Map<String, dynamic>
        : null;
    final dxcc = qso?['dxcc'] is Map<String, dynamic>
        ? qso!['dxcc'] as Map<String, dynamic>
        : null;

    return StatisticsModel(
      totalQsos:     _parseInt(qso?['total'] ?? json['total_qsos'] ?? json['totalqsos'] ?? json['total']),
      todayQsos:     _parseInt(activity?['today'] ?? json['Today'] ?? json['today_qsos'] ?? json['todayqsos']),
      monthQsos:     _parseInt(activity?['month'] ?? json['month_qsos'] ?? json['monthqsos']),
      yearQsos:      _parseInt(activity?['year']  ?? json['year_qsos']  ?? json['yearqsos']),
      dxccWorked:    _parseInt(dxcc?['worked']),
      dxccConfirmed: _parseInt(dxcc?['confirmed']),
      dxccAvailable: _parseInt(dxcc?['available']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}
