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
    this.lastWorkedDate,
    this.lastWorkedBand,
    this.lastWorkedMode,
  });

  factory CallsignLookupModel.fromJson(
      String callsign, Map<String, dynamic> json) {
    final callbook = json['callbook'] as Map<String, dynamic>?;

    // Full name: prefer name_fmt ("Erkin Mercan"), else combine fname + name_last
    final nameFmt = _str(callbook?['name_fmt']);
    final fname   = _str(callbook?['fname']);
    final nameLast = _str(callbook?['name_last']);
    final fullName = nameFmt ??
        [fname, nameLast].where((s) => s != null && s.isNotEmpty).join(' ').trim();

    final rawImage = _str(callbook?['image']);
    final imageUrl = (rawImage != null && rawImage.isNotEmpty && rawImage != 'null')
        ? rawImage
        : null;

    final qslMgr = _str(callbook?['qslmgr']);

    return CallsignLookupModel(
      callsign: callsign.toUpperCase(),
      name: fullName.isNotEmpty ? fullName : null,
      country: _str(callbook?['country']) ?? _str(callbook?['land']),
      flag: _str(json['dxcc_flag']),
      continent: _str(json['cont']),
      dxcc: _str(json['dxcc_id']),
      ituZone: _str(callbook?['ituzone']) ?? _str(callbook?['ituz']),
      cqZone: _str(json['dxcc_cqz']) ?? _str(callbook?['cqzone']) ?? _str(callbook?['cqz']),
      gridSquare: _str(callbook?['gridsquare']) ?? _str(callbook?['grid']),
      qth: _str(callbook?['addr2']) ?? _str(callbook?['city']),
      addr1: _str(callbook?['addr1']),
      email: _str(callbook?['email']),
      imageUrl: imageUrl,
      qslManager: qslMgr,
      lotwMember: callbook?['lotw'] == '1' || callbook?['lotw'] == 1 ||
          json['lotw_member'] != null,
      eqslMember: callbook?['eqsl'] == '1' || callbook?['eqsl'] == 1,
      buqslMember: callbook?['mqsl'] == '1' || callbook?['mqsl'] == 1,
      workedBefore: json['call_worked'] == true || json['call_worked'] == 1,
    );
  }

  static String? _str(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty || s == 'null' ? null : s;
  }
}
