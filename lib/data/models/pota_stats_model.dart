class PotaParkInfo {
  final String reference;
  final String name;
  final String locationDesc;
  final int qsoCount;

  const PotaParkInfo({
    required this.reference,
    required this.name,
    required this.locationDesc,
    required this.qsoCount,
  });

  bool get isActivated => qsoCount >= 10;
}

class PotaStats {
  final int totalQsos;
  final List<PotaParkInfo> parks;
  final int activatedCount;

  const PotaStats({
    required this.totalQsos,
    required this.parks,
    required this.activatedCount,
  });
}
