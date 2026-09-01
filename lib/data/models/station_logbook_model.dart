class StationLogbookModel {
  final int id;
  final String name;
  final bool active;
  final List<int> stationIds;

  // Legacy fields kept for UI compat — not populated from v2 API.
  final String? publicSlug;
  final bool publicSearch;

  const StationLogbookModel({
    required this.id,
    required this.name,
    this.active = false,
    this.stationIds = const [],
    this.publicSlug,
    this.publicSearch = false,
  });

  factory StationLogbookModel.fromJson(Map<String, dynamic> json) {
    // v2 API: {id, name, active, station_ids}
    // legacy: {logbook_id, logbook_name, ...}
    final isV2 = json.containsKey('station_ids') || json.containsKey('active');

    List<int> stationIds = const [];
    if (isV2) {
      final raw = json['station_ids'];
      if (raw is List) {
        stationIds = raw.map((e) => _parseInt(e) ?? 0).where((e) => e > 0).toList();
      }
    }

    return StationLogbookModel(
      id: _parseInt(isV2 ? json['id'] : json['logbook_id']) ?? 0,
      name: (isV2 ? json['name'] : json['logbook_name'])?.toString() ?? '',
      active: isV2
          ? (json['active'] == true)
          : json['logbook_active']?.toString() == '1',
      stationIds: stationIds,
      publicSlug: json['public_slug']?.toString(),
      publicSearch: json['public_search']?.toString() == '1',
    );
  }

  StationLogbookModel copyWith({
    int? id,
    String? name,
    bool? active,
    List<int>? stationIds,
    String? publicSlug,
    bool? publicSearch,
  }) {
    return StationLogbookModel(
      id: id ?? this.id,
      name: name ?? this.name,
      active: active ?? this.active,
      stationIds: stationIds ?? this.stationIds,
      publicSlug: publicSlug ?? this.publicSlug,
      publicSearch: publicSearch ?? this.publicSearch,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}
