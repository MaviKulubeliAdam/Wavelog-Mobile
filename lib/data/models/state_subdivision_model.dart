class StateSubdivision {
  final String code;
  final String name;

  const StateSubdivision({required this.code, required this.name});

  factory StateSubdivision.fromJson(Map<String, dynamic> j) => StateSubdivision(
        code: j['code']?.toString() ?? '',
        name: j['name']?.toString() ?? '',
      );

  String get displayName => '$name ($code)';
}
