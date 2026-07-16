class BandCondition {
  final String band;       // "80m-40m", "30m-20m", "17m-15m", "12m-10m"
  final String time;       // "day" | "night"
  final String condition;  // "Good" | "Fair" | "Poor"

  const BandCondition({
    required this.band,
    required this.time,
    required this.condition,
  });
}

class SolarDataModel {
  final String updated;
  final int solarFlux;
  final int solarWind;
  final int sunspots;
  final int kIndex;
  final int aIndex;
  final String signalNoise;
  final List<BandCondition> conditions;

  const SolarDataModel({
    required this.updated,
    required this.solarFlux,
    required this.solarWind,
    required this.sunspots,
    required this.kIndex,
    required this.aIndex,
    required this.signalNoise,
    required this.conditions,
  });

  List<BandCondition> get dayConditions =>
      conditions.where((c) => c.time == 'day').toList();

  List<BandCondition> get nightConditions =>
      conditions.where((c) => c.time == 'night').toList();
}
