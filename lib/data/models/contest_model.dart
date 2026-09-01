class ContestTemplate {
  final int id;
  final String name;
  final String adifName;

  const ContestTemplate({
    required this.id,
    required this.name,
    required this.adifName,
  });

  factory ContestTemplate.fromJson(Map<String, dynamic> j) => ContestTemplate(
        id:       int.tryParse(j['id']?.toString() ?? '') ?? 0,
        name:     j['name']?.toString() ?? '',
        adifName: (j['contest'] ?? j['adif_name'] ?? j['adifname'])?.toString() ?? '',
      );
}

class ContestSession {
  final int id;
  final String contestName;
  final String adifName;
  final DateTime timeStart;
  final DateTime? timeEnd;
  final int stationId;
  final int qsoCount;
  final String customName;
  final List<String> exchangeFields;

  const ContestSession({
    required this.id,
    required this.contestName,
    required this.adifName,
    required this.timeStart,
    this.timeEnd,
    required this.stationId,
    required this.qsoCount,
    this.customName = '',
    this.exchangeFields = const ['serial'],
  });

  factory ContestSession.fromJson(Map<String, dynamic> j) {
    DateTime parseDate(String? s) {
      if (s == null || s.isEmpty) return DateTime.now().toUtc();
      return DateTime.tryParse(s)?.toUtc() ?? DateTime.now().toUtc();
    }

    String customName = j['custom_name']?.toString() ?? '';

    // v2: settings.exchangefields; legacy: exchange_fields flat array
    List<String> exchangeFields = const ['serial'];
    final settings = j['settings'];
    final efV2 = settings is Map ? settings['exchangefields'] : null;
    final ef = efV2 ?? j['exchange_fields'];
    if (ef is List && ef.isNotEmpty) {
      exchangeFields = ef.map((e) => e.toString()).toList();
    }

    return ContestSession(
      id:             int.tryParse(j['id']?.toString() ?? '') ?? 0,
      contestName:    j['contest_name']?.toString() ?? '',
      adifName:       (j['contest'] ?? j['adif_name'] ?? j['adifname'])?.toString() ?? '',
      timeStart:      parseDate(j['time_start']?.toString()),
      timeEnd:        j['time_end'] != null && j['time_end'].toString().isNotEmpty
                          ? DateTime.tryParse(j['time_end'].toString())?.toUtc()
                          : null,
      stationId:      int.tryParse(j['station_id']?.toString() ?? '') ?? 0,
      qsoCount:       int.tryParse(j['qso_count']?.toString() ?? '') ?? 0,
      customName:     customName,
      exchangeFields: exchangeFields,
    );
  }

  bool get isActive {
    final now = DateTime.now().toUtc();
    if (timeEnd == null) return true;
    return now.isBefore(timeEnd!);
  }
}
