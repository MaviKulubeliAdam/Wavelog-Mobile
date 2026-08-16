import 'package:hive_flutter/hive_flutter.dart';

part 'qso_model.g.dart';

@HiveType(typeId: 0)
class QsoModel extends HiveObject {
  @HiveField(0)
  final String? localId;

  @HiveField(1)
  final String callsign;

  @HiveField(2)
  final DateTime dateTimeOn;

  @HiveField(3)
  final String band;

  @HiveField(4)
  final double? freqMhz;

  @HiveField(5)
  final String mode;

  @HiveField(6)
  final String? submode;

  @HiveField(7)
  final String rstSent;

  @HiveField(8)
  final String rstRcvd;

  @HiveField(9)
  final String? name;

  @HiveField(10)
  final String? qth;

  @HiveField(11)
  final String? gridSquare;

  @HiveField(12)
  final String? comment;

  @HiveField(13)
  final String? notes;

  @HiveField(14)
  final String? dxcc;

  @HiveField(15)
  final String? country;

  @HiveField(16)
  final String? continent;

  @HiveField(17)
  final int stationProfileId;

  @HiveField(18)
  final bool synced;

  @HiveField(19)
  final DateTime? syncedAt;

  // All raw ADIF fields — provides access to any field not explicitly mapped
  @HiveField(20)
  final Map<String, String>? rawAdif;

  QsoModel({
    this.localId,
    required this.callsign,
    required this.dateTimeOn,
    required this.band,
    this.freqMhz,
    required this.mode,
    this.submode,
    required this.rstSent,
    required this.rstRcvd,
    this.name,
    this.qth,
    this.gridSquare,
    this.comment,
    this.notes,
    this.dxcc,
    this.country,
    this.continent,
    required this.stationProfileId,
    this.synced = false,
    this.syncedAt,
    this.rawAdif,
  });

  // ── Computed getters from rawAdif ──────────────────────────────────────────

  int? get cqZone => int.tryParse(rawAdif?['CQZ'] ?? '');
  int? get ituZone => int.tryParse(rawAdif?['ITUZ'] ?? '');
  String? get state => rawAdif?['STATE'];
  String? get county => rawAdif?['CNTY'];

  // QSL
  String? get qslSent => rawAdif?['QSL_SENT'];
  String? get qslRcvd => rawAdif?['QSL_RCVD'];
  String? get qslSentVia => rawAdif?['QSL_SENT_VIA'];
  String? get qslRcvdVia => rawAdif?['QSL_RCVD_VIA'];
  String? get qslRdate => rawAdif?['QSLRDATE'];
  String? get qslSdate => rawAdif?['QSLSDATE'];
  String? get lotwSent => rawAdif?['LOTW_QSL_SENT'];
  String? get lotwRcvd => rawAdif?['LOTW_QSL_RCVD'];
  String? get lotwSdate => rawAdif?['LOTW_QSLSDATE'];
  String? get lotwRdate => rawAdif?['LOTW_QSLRDATE'];
  String? get eqslSent => rawAdif?['EQSL_QSL_SENT'];
  String? get eqslRcvd => rawAdif?['EQSL_QSL_RCVD'];
  String? get qrzSent => rawAdif?['QRZCOM_QSO_UPLOAD_STATUS'];
  String? get qrzRcvd => rawAdif?['QRZCOM_QSO_DOWNLOAD_STATUS'];
  String? get clublogStatus => rawAdif?['CLUBLOG_QSO_UPLOAD_STATUS'];
  String? get hrdlogStatus => rawAdif?['HRDLOG_QSO_UPLOAD_STATUS'];

  // Propagation / technical
  String? get txPower => rawAdif?['TX_PWR'];
  String? get propMode => rawAdif?['PROP_MODE'];
  String? get satName => rawAdif?['SAT_NAME'];
  String? get satMode => rawAdif?['SAT_MODE'];
  String? get antenna => rawAdif?['ANTENNA'];
  String? get distance => rawAdif?['DISTANCE'];
  String? get timeOff => rawAdif?['TIME_OFF'];

  // Awards / references
  String? get iota => rawAdif?['IOTA'];
  String? get sotaRef => rawAdif?['SOTA_REF'];
  String? get wwffRef => rawAdif?['WWFF_REF'];
  String? get potaRef => rawAdif?['POTA_REF'];
  String? get sigRef => rawAdif?['SIG_INFO'];
  String? get pfx => rawAdif?['PFX'];

  // Contest
  String? get contestId => rawAdif?['CONTEST_ID'];
  String? get srxString => rawAdif?['SRX_STRING'];
  String? get stxString => rawAdif?['STX_STRING'];
  String? get srx => rawAdif?['SRX'];
  String? get stx => rawAdif?['STX'];

  // My station
  String? get myCallsign => rawAdif?['STATION_CALLSIGN'] ?? rawAdif?['OPERATOR'];
  String? get myGridSquare => rawAdif?['MY_GRIDSQUARE'];
  String? get myCity => rawAdif?['MY_CITY'];
  String? get myCountry => rawAdif?['MY_COUNTRY'];
  int? get myCqZone => int.tryParse(rawAdif?['MY_CQ_ZONE'] ?? '');
  int? get myItuZone => int.tryParse(rawAdif?['MY_ITU_ZONE'] ?? '');
  String? get mySota => rawAdif?['MY_SOTA_REF'];
  String? get myPota => rawAdif?['MY_POTA_REF'];
  String? get myIota => rawAdif?['MY_IOTA'];
  String? get myState => rawAdif?['MY_STATE'];

  // Geospace conditions
  String? get aIndex => rawAdif?['A_INDEX'];
  String? get kIndex => rawAdif?['K_INDEX'];
  String? get sfi => rawAdif?['SFI'];

  // Server-side database ID — present on QSOs fetched from Wavelog API
  int? get serverId =>
      int.tryParse(rawAdif?['ID'] ?? rawAdif?['APP_WAVELOG_QSO_ID'] ?? '');

  factory QsoModel.fromJson(Map<String, dynamic> json) {
    // Detect API v2 format (lowercase keys) vs ADIF legacy (UPPERCASE keys).
    // v2 uses 'call', 'band', 'rst_sent', 'qso_date' (full datetime), freq in Hz.
    final isV2 = json.containsKey('call') || json.containsKey('qso_date');

    // ── Date / time ──────────────────────────────────────────────────────────
    DateTime dateTime;
    try {
      if (isV2) {
        // v2 qso_date comes from COL_TIME_ON: "2026-08-11 21:41:00" (UTC)
        final raw = json['qso_date']?.toString() ?? '';
        dateTime = DateTime.parse(raw.replaceFirst(' ', 'T') + 'Z').toUtc();
      } else {
        final dateStr = json['QSO_DATE']?.toString() ?? '';
        final timeStr = json['TIME_ON']?.toString() ?? '0000';
        if (dateStr.length >= 8) {
          final y = int.parse(dateStr.substring(0, 4));
          final mo = int.parse(dateStr.substring(4, 6));
          final d = int.parse(dateStr.substring(6, 8));
          final h = timeStr.length >= 2 ? int.parse(timeStr.substring(0, 2)) : 0;
          final m = timeStr.length >= 4 ? int.parse(timeStr.substring(2, 4)) : 0;
          final s = timeStr.length >= 6 ? int.parse(timeStr.substring(4, 6)) : 0;
          dateTime = DateTime.utc(y, mo, d, h, m, s);
        } else {
          dateTime = DateTime.now().toUtc();
        }
      }
    } catch (_) {
      dateTime = DateTime.now().toUtc();
    }

    // ── rawAdif — uppercase all keys; add ADIF aliases for v2 snake_case keys ─
    final raw = <String, String>{};
    for (final entry in json.entries) {
      if (entry.value != null) {
        raw[entry.key.toUpperCase()] = entry.value.toString();
      }
    }
    if (isV2) {
      // Map snake_case v2 keys → ADIF uppercase so rawAdif getters work
      void alias(String v2, String adif) {
        if (json[v2] != null) raw[adif] = json[v2].toString();
      }
      alias('rst_sent',  'RST_SENT');
      alias('rst_rcvd',  'RST_RCVD');
      alias('gridsquare','GRIDSQUARE');
      alias('tx_pwr',    'TX_PWR');
      alias('prop_mode', 'PROP_MODE');
      alias('sat_name',  'SAT_NAME');
      alias('sat_mode',  'SAT_MODE');
      alias('sota_ref',  'SOTA_REF');
      alias('pota_ref',  'POTA_REF');
      alias('wwff_ref',  'WWFF_REF');
      alias('sig_info',  'SIG_INFO');
      alias('srx_string','SRX_STRING');
      alias('stx_string','STX_STRING');
      alias('band_rx',   'BAND_RX');
    }

    // ── Frequency — v2 is Hz, ADIF is MHz ────────────────────────────────────
    double? freqMhz;
    if (isV2) {
      final hz = double.tryParse(json['freq']?.toString() ?? '');
      freqMhz = (hz != null && hz > 0) ? hz / 1000000.0 : null;
    } else {
      freqMhz = double.tryParse(json['FREQ']?.toString() ?? '');
    }

    // ── Field helpers ─────────────────────────────────────────────────────────
    String? pick(String v2Key, String adifKey) =>
        (isV2 ? json[v2Key] : json[adifKey])?.toString();

    return QsoModel(
      callsign: pick('call',       'CALL')       ?? '',
      dateTimeOn: dateTime,
      band:     pick('band',       'BAND')       ?? '',
      freqMhz: freqMhz,
      mode:     pick('mode',       'MODE')       ?? '',
      submode:  pick('submode',    'SUBMODE'),
      rstSent:  pick('rst_sent',   'RST_SENT')   ?? '59',
      rstRcvd:  pick('rst_rcvd',   'RST_RCVD')   ?? '59',
      name:     pick('name',       'NAME'),
      qth:      pick('qth',        'QTH'),
      gridSquare: pick('gridsquare', 'GRIDSQUARE'),
      comment:  pick('comment',    'COMMENT'),
      notes:    pick('notes',      'NOTES'),
      dxcc:     pick('dxcc',       'DXCC'),
      country:  pick('country',    'COUNTRY'),
      continent: (isV2 ? json['cont'] : json['CONT'])?.toString(),
      stationProfileId: isV2
          ? (int.tryParse(json['station_id']?.toString() ?? '') ?? 0)
          : (int.tryParse(json['station_profile_id']?.toString() ?? '') ?? 0),
      synced: true,
      rawAdif: raw,
    );
  }

  QsoModel copyWith({
    String? localId,
    String? callsign,
    DateTime? dateTimeOn,
    String? band,
    double? freqMhz,
    String? mode,
    String? submode,
    String? rstSent,
    String? rstRcvd,
    String? name,
    String? qth,
    String? gridSquare,
    String? comment,
    String? notes,
    String? dxcc,
    String? country,
    String? continent,
    int? stationProfileId,
    bool? synced,
    DateTime? syncedAt,
    Map<String, String>? rawAdif,
  }) {
    return QsoModel(
      localId: localId ?? this.localId,
      callsign: callsign ?? this.callsign,
      dateTimeOn: dateTimeOn ?? this.dateTimeOn,
      band: band ?? this.band,
      freqMhz: freqMhz ?? this.freqMhz,
      mode: mode ?? this.mode,
      submode: submode ?? this.submode,
      rstSent: rstSent ?? this.rstSent,
      rstRcvd: rstRcvd ?? this.rstRcvd,
      name: name ?? this.name,
      qth: qth ?? this.qth,
      gridSquare: gridSquare ?? this.gridSquare,
      comment: comment ?? this.comment,
      notes: notes ?? this.notes,
      dxcc: dxcc ?? this.dxcc,
      country: country ?? this.country,
      continent: continent ?? this.continent,
      stationProfileId: stationProfileId ?? this.stationProfileId,
      synced: synced ?? this.synced,
      syncedAt: syncedAt ?? this.syncedAt,
      rawAdif: rawAdif ?? this.rawAdif,
    );
  }
}
