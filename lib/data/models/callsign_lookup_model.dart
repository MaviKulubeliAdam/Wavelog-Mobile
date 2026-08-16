class CallsignLookupModel {
  final String callsign;
  final String? name;
  final String? country;
  final String? flag;
  final String? continent;
  final String? dxcc;
  final String? ituZone;
  final String? cqZone;
  final String? gridSquare;
  final String? qth;
  final String? addr1;
  final String? email;
  final String? imageUrl;
  final String? qslManager;
  final bool lotwMember;
  final bool eqslMember;
  final bool buqslMember;
  final bool workedBefore;
  final bool qslConfirmed;
  final String? lastWorkedDate;
  final String? lastWorkedBand;
  final String? lastWorkedMode;

  const CallsignLookupModel({
    required this.callsign,
    this.name,
    this.country,
    this.flag,
    this.continent,
    this.dxcc,
    this.ituZone,
    this.cqZone,
    this.gridSquare,
    this.qth,
    this.addr1,
    this.email,
    this.imageUrl,
    this.qslManager,
    this.lotwMember = false,
    this.eqslMember = false,
    this.buqslMember = false,
    this.workedBefore = false,
    this.qslConfirmed = false,
    this.lastWorkedDate,
    this.lastWorkedBand,
    this.lastWorkedMode,
  });

  factory CallsignLookupModel.fromJson(
      String callsign, Map<String, dynamic> json) {
    // v2 returns a flat object; legacy format had a nested 'callbook' sub-object.
    final callbook = json['callbook'] as Map<String, dynamic>?;

    // Name: v2 flat field 'name', or callbook sub-object fields
    final name = _str(json['name']) ??
        _str(callbook?['name_fmt']) ??
        [_str(callbook?['fname']), _str(callbook?['name_last'])]
            .where((s) => s != null && s.isNotEmpty)
            .join(' ')
            .trim();

    final rawImage = _str(callbook?['image']);
    final imageUrl = (rawImage != null && rawImage.isNotEmpty && rawImage != 'null')
        ? rawImage
        : null;

    // lotw_member: v2 returns days-since-upload string when member, false when not
    final lotwRaw = json['lotw_member'];
    final lotwMember = (lotwRaw != null && lotwRaw != false && lotwRaw.toString().isNotEmpty)
        ? true
        : (callbook?['lotw'] == '1' || callbook?['lotw'] == 1);

    // ITU zone: full detail adds dxcc_ituz; callbook may have ituzone/ituz
    final ituZone = _str(json['dxcc_ituz']?.toString()) ??
        _str(callbook?['ituzone']) ??
        _str(callbook?['ituz']);

    // QSL confirmed: full detail returns call_confirmed
    final qslConfirmed = json['call_confirmed'] == true || json['call_confirmed'] == 1;

    return CallsignLookupModel(
      callsign: callsign.toUpperCase(),
      name: name.isNotEmpty ? name : null,
      // v2: 'dxcc' = country name, callbook: 'country' or 'land'
      country: _str(json['dxcc']) ?? _str(callbook?['country']) ?? _str(callbook?['land']),
      flag: _str(json['dxcc_flag']),
      continent: _str(json['cont']),
      dxcc: _str(json['dxcc_id']),
      ituZone: ituZone,
      cqZone: _str(json['dxcc_cqz']) ?? _str(callbook?['cqzone']) ?? _str(callbook?['cqz']),
      gridSquare: _str(json['gridsquare']) ?? _str(callbook?['gridsquare']) ?? _str(callbook?['grid']),
      qth: _str(json['location']) ?? _str(callbook?['addr2']) ?? _str(callbook?['city']),
      addr1: _str(callbook?['addr1']),
      email: _str(callbook?['email']),
      imageUrl: imageUrl,
      qslManager: _str(json['qsl_manager']) ?? _str(callbook?['qslmgr']),
      lotwMember: lotwMember,
      eqslMember: callbook?['eqsl'] == '1' || callbook?['eqsl'] == 1,
      buqslMember: callbook?['mqsl'] == '1' || callbook?['mqsl'] == 1,
      workedBefore: json['workedBefore'] == true || json['workedBefore'] == 1 ||
          json['call_worked'] == true || json['call_worked'] == 1,
      qslConfirmed: qslConfirmed,
    );
  }

  static String? _str(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty || s == 'null' ? null : s;
  }
}
