class ApiEndpoints {
  ApiEndpoints._();

  // Primary paths (URL rewriting enabled)
  static const String qsoImport = '/index.php/api/qso/';
  static const String privateLookup = '/index.php/api/private_lookup';
  static const String createStation = '/index.php/api/create_station';
  static const String version = '/index.php/api/version';

  static String stationInfo(String apiKey) =>
      '/index.php/api/station_info/$apiKey';

  static String statistics(String apiKey) =>
      '/index.php/api/statistics/$apiKey';

  // Mobile App API endpoints (Api_mobile.php)
  static const String mobileGetContacts = '/index.php/api_mobile/get_contacts';
  static const String mobileDeleteQso   = '/index.php/api_mobile/delete_qso';
  static const String mobileUpdateQso   = '/index.php/api_mobile/update_qso';

  // Station location CRUD
  static const String mobileGetStationDetail  = '/index.php/api_mobile/get_station_detail';
  static const String mobileUpdateStation     = '/index.php/api_mobile/update_station';
  static const String mobileDeleteStation     = '/index.php/api_mobile/delete_station';
  static const String mobileCloneStation      = '/index.php/api_mobile/clone_station';
  static const String mobileSetActiveStation  = '/index.php/api_mobile/set_active_station';

  // Logbook CRUD
  static const String mobileGetLogbooks      = '/index.php/api_mobile/get_logbooks';
  static const String mobileCreateLogbook    = '/index.php/api_mobile/create_logbook';
  static const String mobileUpdateLogbook    = '/index.php/api_mobile/update_logbook';
  static const String mobileDeleteLogbook    = '/index.php/api_mobile/delete_logbook';
  static const String mobileSetActiveLogbook = '/index.php/api_mobile/set_active_logbook';

  // Location–logbook linking
  static const String mobileLinkStation      = '/index.php/api_mobile/link_station_to_logbook';
  static const String mobileUnlinkStation    = '/index.php/api_mobile/unlink_station_from_logbook';

  // DXCC & state lookup
  static const String mobileGetDxccList  = '/index.php/api_mobile/get_dxcc_list';
  static const String mobileGetStateList = '/index.php/api_mobile/get_state_list';

  // Contest endpoints (require updated mobile patch)
  static const String mobileGetContestList        = '/index.php/api_mobile/get_contest_list';
  static const String mobileGetContestSessions   = '/index.php/api_mobile/get_contest_sessions';
  static const String mobileCreateContestSession = '/index.php/api_mobile/create_contest_session';
  static const String mobileUpdateContestSession = '/index.php/api_mobile/update_contest_session';
  static const String mobileDeleteContestSession = '/index.php/api_mobile/delete_contest_session';
  static const String mobileLogContestQso        = '/index.php/api_mobile/log_contest_qso';
}
