class ApiEndpoints {
  ApiEndpoints._();

  static const String _v2 = '/index.php/api/v2';

  // QSO
  static const String qso       = '$_v2/qso';
  static String qsoById(int id) => '$_v2/qso/$id';

  // Station
  static const String station         = '$_v2/station';
  static String stationById(int id)   => '$_v2/station/$id';

  // Logbook
  static const String logbook         = '$_v2/logbook';
  static String logbookById(int id)   => '$_v2/logbook/$id';

  // Catalog — DXCC, subdivisions, contest list (?topic=...)
  static const String catalog         = '$_v2/catalog';

  // Contest sessions
  static const String contest         = '$_v2/contest';
  static String contestById(int id)   => '$_v2/contest/$id';

  // Statistics & misc
  static const String statistics = '$_v2/statistic';
  static const String lookup     = '$_v2/lookup';
  static const String version      = '$_v2/status';
  static const String confirmation = '$_v2/confirmation';
}
