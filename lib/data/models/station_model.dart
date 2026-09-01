class StationModel {
  final int id;
  final String profileName;
  final String callsign;
  final String? gridSquare;
  final String? city;
  final String? country;
  final int? dxcc;
  final int? power;
  final bool isActive;

  // Location
  final String? state;
  final String? county;
  final int? cqZone;
  final int? ituZone;

  // Award references
  final String? iota;
  final String? sota;
  final String? wwff;
  final String? pota;
  final String? sig;
  final String? sigInfo;

  // eQSL
  final String? eqslQthNickname;
  final String? eqslDefaultQslMsg;

  // Integrations
  final String? qrzApiKey;
  final String? hrdlogUsername;
  final String? hrdlogCode;
  final String? webAdifApiKey;
  // -1 = Disabled, 0 = Enabled (batch), 1 = Realtime
  final int qrzRealtime;
  final bool webAdifRealtime;
  final bool clublogRealtime;
  final bool clublogIgnore;
  // -1 = Disabled, 0 = No (batch), 1 = Yes (realtime)
  final int hrdlogRealtime;

  // OQRS
  final bool oqrsEnabled;
  final String? oqrsText;
  final String? oqrsEmail;

  const StationModel({
    required this.id,
    required this.profileName,
    required this.callsign,
    this.gridSquare,
    this.city,
    this.country,
    this.dxcc,
    this.power,
    this.isActive = false,
    this.state,
    this.county,
    this.cqZone,
    this.ituZone,
    this.iota,
    this.sota,
    this.wwff,
    this.pota,
    this.sig,
    this.sigInfo,
    this.eqslQthNickname,
    this.eqslDefaultQslMsg,
    this.qrzApiKey,
    this.hrdlogUsername,
    this.hrdlogCode,
    this.webAdifApiKey,
    this.qrzRealtime = -1,
    this.webAdifRealtime = false,
    this.clublogRealtime = false,
    this.clublogIgnore = false,
    this.hrdlogRealtime = -1,
    this.oqrsEnabled = false,
    this.oqrsText,
    this.oqrsEmail,
  });

  factory StationModel.fromJson(Map<String, dynamic> json) {
    // v2 native API returns short names: id, name, callsign, active (bool)
    // api_mobile patch returns legacy DB names: station_id, station_profile_name, station_active ('1')
    final isV2Format = json.containsKey('id') && !json.containsKey('station_id');
    return StationModel(
      id: _parseInt(isV2Format ? json['id'] : json['station_id']) ?? 0,
      profileName: (isV2Format ? json['name'] : json['station_profile_name'])?.toString() ?? '',
      callsign: (isV2Format ? json['callsign'] : json['station_callsign'])?.toString() ?? '',
      gridSquare: (isV2Format ? json['gridsquare'] : json['station_gridsquare'])?.toString(),
      city: (isV2Format ? json['city'] : json['station_city'])?.toString(),
      country: json['country']?.toString(),
      dxcc: _parseInt(isV2Format ? json['dxcc'] : json['station_dxcc']),
      power: _parseInt(isV2Format ? json['power'] : json['station_power']),
      isActive: isV2Format
          ? (json['active'] == true)
          : json['station_active']?.toString() == '1',
      state: json['state']?.toString() ?? json['station_state']?.toString(),
      county: (isV2Format ? json['cnty'] : json['station_cnty'])?.toString() ?? json['county']?.toString(),
      cqZone: _parseInt(isV2Format ? json['cq'] : json['station_cq']),
      ituZone: _parseInt(isV2Format ? json['itu'] : json['station_itu']),
      iota: (isV2Format ? json['iota'] : json['station_iota'])?.toString(),
      sota: (isV2Format ? json['sota'] : json['station_sota'])?.toString(),
      wwff: (isV2Format ? json['wwff'] : json['station_wwff'])?.toString(),
      pota: (isV2Format ? json['pota'] : json['station_pota'])?.toString(),
      sig: (isV2Format ? json['sig'] : json['station_sig'])?.toString(),
      sigInfo: (isV2Format ? json['sig_info'] : json['station_sig_info'])?.toString(),
      eqslQthNickname: json['eqslqthnickname']?.toString(),
      eqslDefaultQslMsg: json['eqsl_default_qslmsg']?.toString(),
      qrzApiKey: json['qrzapikey']?.toString() ?? json['qrz_api']?.toString(),
      hrdlogUsername: json['hrdlog_username']?.toString(),
      hrdlogCode: json['hrdlog_code']?.toString(),
      webAdifApiKey: json['webadifapikey']?.toString(),
      qrzRealtime: _parseInt(json['qrzrealtime']) ?? -1,
      webAdifRealtime: _parseBool(json['webadifrealtime']),
      clublogRealtime: _parseBool(json['clublogrealtime']),
      clublogIgnore: _parseBool(json['clublogignore']),
      hrdlogRealtime: _parseInt(json['hrdlogrealtime']) ?? -1,
      oqrsEnabled: _parseBool(json['oqrs']),
      oqrsText: json['oqrs_text']?.toString(),
      oqrsEmail: json['oqrs_email']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'station_profile_name': profileName,
      'station_callsign': callsign,
      'station_gridsquare': gridSquare ?? '',
      'station_city': city ?? '',
      'station_active': isActive ? '1' : '0',
    };

    if (dxcc != null && dxcc! > 0) map['station_dxcc'] = dxcc;
    if (power != null && power! > 0) map['station_power'] = power.toString();

    if (state != null && state!.isNotEmpty) map['state'] = state;
    if (county != null && county!.isNotEmpty) map['station_cnty'] = county;
    if (cqZone != null && cqZone! > 0) map['station_cq'] = cqZone.toString();
    if (ituZone != null && ituZone! > 0) map['station_itu'] = ituZone.toString();

    if (iota != null && iota!.isNotEmpty) map['station_iota'] = iota;
    if (sota != null && sota!.isNotEmpty) map['station_sota'] = sota;
    if (wwff != null && wwff!.isNotEmpty) map['station_wwff'] = wwff;
    if (pota != null && pota!.isNotEmpty) map['station_pota'] = pota;
    if (sig != null && sig!.isNotEmpty) map['station_sig'] = sig;
    if (sigInfo != null && sigInfo!.isNotEmpty) map['station_sig_info'] = sigInfo;

    if (eqslQthNickname != null && eqslQthNickname!.isNotEmpty) {
      map['eqslqthnickname'] = eqslQthNickname;
    }
    if (eqslDefaultQslMsg != null && eqslDefaultQslMsg!.isNotEmpty) {
      map['eqsl_default_qslmsg'] = eqslDefaultQslMsg;
    }

    if (qrzApiKey != null && qrzApiKey!.isNotEmpty) map['qrzapikey'] = qrzApiKey;
    if (hrdlogUsername != null && hrdlogUsername!.isNotEmpty) {
      map['hrdlog_username'] = hrdlogUsername;
    }
    if (hrdlogCode != null && hrdlogCode!.isNotEmpty) map['hrdlog_code'] = hrdlogCode;
    if (webAdifApiKey != null && webAdifApiKey!.isNotEmpty) map['webadifapikey'] = webAdifApiKey;

    map['qrzrealtime'] = qrzRealtime.toString();
    map['webadifrealtime'] = webAdifRealtime ? '1' : '0';
    map['clublogrealtime'] = clublogRealtime ? '1' : '0';
    map['clublogignore'] = clublogIgnore ? '1' : '0';
    map['hrdlogrealtime'] = hrdlogRealtime.toString();
    map['oqrs'] = oqrsEnabled ? '1' : '0';
    if (oqrsText != null && oqrsText!.isNotEmpty) map['oqrs_text'] = oqrsText;
    if (oqrsEmail != null && oqrsEmail!.isNotEmpty) map['oqrs_email'] = oqrsEmail;

    return map;
  }

  StationModel copyWith({
    int? id,
    String? profileName,
    String? callsign,
    String? gridSquare,
    String? city,
    String? country,
    int? dxcc,
    int? power,
    bool? isActive,
    String? state,
    String? county,
    int? cqZone,
    int? ituZone,
    String? iota,
    String? sota,
    String? wwff,
    String? pota,
    String? sig,
    String? sigInfo,
    String? eqslQthNickname,
    String? eqslDefaultQslMsg,
    String? qrzApiKey,
    String? hrdlogUsername,
    String? hrdlogCode,
    String? webAdifApiKey,
    int? qrzRealtime,
    bool? webAdifRealtime,
    bool? clublogRealtime,
    bool? clublogIgnore,
    int? hrdlogRealtime,
    bool? oqrsEnabled,
    String? oqrsText,
    String? oqrsEmail,
  }) {
    return StationModel(
      id: id ?? this.id,
      profileName: profileName ?? this.profileName,
      callsign: callsign ?? this.callsign,
      gridSquare: gridSquare ?? this.gridSquare,
      city: city ?? this.city,
      country: country ?? this.country,
      dxcc: dxcc ?? this.dxcc,
      power: power ?? this.power,
      isActive: isActive ?? this.isActive,
      state: state ?? this.state,
      county: county ?? this.county,
      cqZone: cqZone ?? this.cqZone,
      ituZone: ituZone ?? this.ituZone,
      iota: iota ?? this.iota,
      sota: sota ?? this.sota,
      wwff: wwff ?? this.wwff,
      pota: pota ?? this.pota,
      sig: sig ?? this.sig,
      sigInfo: sigInfo ?? this.sigInfo,
      eqslQthNickname: eqslQthNickname ?? this.eqslQthNickname,
      eqslDefaultQslMsg: eqslDefaultQslMsg ?? this.eqslDefaultQslMsg,
      qrzApiKey: qrzApiKey ?? this.qrzApiKey,
      hrdlogUsername: hrdlogUsername ?? this.hrdlogUsername,
      hrdlogCode: hrdlogCode ?? this.hrdlogCode,
      webAdifApiKey: webAdifApiKey ?? this.webAdifApiKey,
      qrzRealtime: qrzRealtime ?? this.qrzRealtime,
      webAdifRealtime: webAdifRealtime ?? this.webAdifRealtime,
      clublogRealtime: clublogRealtime ?? this.clublogRealtime,
      clublogIgnore: clublogIgnore ?? this.clublogIgnore,
      hrdlogRealtime: hrdlogRealtime ?? this.hrdlogRealtime,
      oqrsEnabled: oqrsEnabled ?? this.oqrsEnabled,
      oqrsText: oqrsText ?? this.oqrsText,
      oqrsEmail: oqrsEmail ?? this.oqrsEmail,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    return value.toString() == '1';
  }
}
