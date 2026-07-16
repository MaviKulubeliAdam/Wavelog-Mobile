class DxccEntity {
  final int adif;
  final String name;
  final String prefix;
  final String continent;
  final int cqZone;
  final int ituZone;
  final bool deleted;

  const DxccEntity({
    required this.adif,
    required this.name,
    required this.prefix,
    this.continent = '',
    required this.cqZone,
    required this.ituZone,
    this.deleted = false,
  });

  factory DxccEntity.fromJson(Map<String, dynamic> j) => DxccEntity(
        adif:      _i(j['adif']),
        name:      j['name']?.toString() ?? '',
        prefix:    j['prefix']?.toString() ?? '',
        continent: j['continent']?.toString() ?? j['cont']?.toString() ?? '',
        cqZone:    _i(j['cqz']),
        ituZone:   _i(j['ituz']),
        deleted:   j['deleted'] == true,
      );

  static int _i(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }

  String get displayName => '$name ($prefix)';
}
