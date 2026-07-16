import 'station_model.dart';

class StationLogbookModel {
  final int id;
  final String name;
  final String? publicSlug;
  final bool publicSearch;
  final List<StationModel> locations;

  const StationLogbookModel({
    required this.id,
    required this.name,
    this.publicSlug,
    this.publicSearch = false,
    this.locations = const [],
  });

  factory StationLogbookModel.fromJson(Map<String, dynamic> json) {
    final rawLocations = json['locations'];
    final locations = (rawLocations is List)
        ? rawLocations
            .map((l) => StationModel.fromJson(l as Map<String, dynamic>))
            .toList()
        : <StationModel>[];

    return StationLogbookModel(
      id: _parseInt(json['logbook_id']) ?? 0,
      name: json['logbook_name']?.toString() ?? '',
      publicSlug: json['public_slug']?.toString(),
      publicSearch: json['public_search']?.toString() == '1',
      locations: locations,
    );
  }

  Map<String, dynamic> toJson() => {
        'logbook_id': id,
        'logbook_name': name,
        if (publicSlug != null) 'public_slug': publicSlug,
        'public_search': publicSearch ? '1' : '0',
      };

  StationLogbookModel copyWith({
    int? id,
    String? name,
    String? publicSlug,
    bool? publicSearch,
    List<StationModel>? locations,
  }) {
    return StationLogbookModel(
      id: id ?? this.id,
      name: name ?? this.name,
      publicSlug: publicSlug ?? this.publicSlug,
      publicSearch: publicSearch ?? this.publicSearch,
      locations: locations ?? this.locations,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}
