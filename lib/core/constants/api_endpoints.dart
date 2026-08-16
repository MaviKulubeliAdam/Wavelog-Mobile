class ApiEndpoints {
  ApiEndpoints._();

  static const String _v2     = '/index.php/api/v2';
  static const String _mobile = '/index.php/api_mobile';

  // ── API v2 (native, Bearer token auth) ──────────────────────────────────────

  // QSO
  static const String qso        = '$_v2/qso';
  static String qsoById(int id)  => '$_v2/qso/$id';

  // Station — list & create via v2; extensions via patch below
  static const String station         = '$_v2/station';
  static String stationById(int id)   => '$_v2/station/$id';

  // Statistics & misc
  static const String statistics = '$_v2/statistic';
  static const String lookup     = '$_v2/lookup';
  static const String version    = '$_v2/version';

  // ── api_mobile patch (Bearer token auth via Authorization header) ────────────
  // These bridge the gap until the missing resources land in native v2.
  // Remove each entry once its v2 counterpart ships and the PR is merged.

  // Station extensions (detail, clone, activate, delete via patch)
  static const String mobileGetStationDetail  = '$_mobile/get_station_detail';
  static const String mobileUpdateStation     = '$_mobile/update_station';
  static const String mobileDeleteStation     = '$_mobile/delete_station';
  static const String mobileCloneStation      = '$_mobile/clone_station';
  static const String mobileSetActiveStation  = '$_mobile/set_active_station';

  // Logbook CRUD
  static const String mobileGetLogbooks      = '$_mobile/get_logbooks';
  static const String mobileCreateLogbook    = '$_mobile/create_logbook';
  static const String mobileUpdateLogbook    = '$_mobile/update_logbook';
  static const String mobileDeleteLogbook    = '$_mobile/delete_logbook';
  static const String mobileSetActiveLogbook = '$_mobile/set_active_logbook';

  // Location–logbook linking
  static const String mobileLinkStation   = '$_mobile/link_station_to_logbook';
  static const String mobileUnlinkStation = '$_mobile/unlink_station_from_logbook';

  // DXCC & state lookup
  static const String mobileGetDxccList  = '$_mobile/get_dxcc_list';
  static const String mobileGetStateList = '$_mobile/get_state_list';

  // Contest
  static const String mobileGetContestList        = '$_mobile/get_contest_list';
  static const String mobileGetContestSessions    = '$_mobile/get_contest_sessions';
  static const String mobileCreateContestSession  = '$_mobile/create_contest_session';
  static const String mobileUpdateContestSession  = '$_mobile/update_contest_session';
  static const String mobileDeleteContestSession  = '$_mobile/delete_contest_session';
  static const String mobileLogContestQso         = '$_mobile/log_contest_qso';
}
