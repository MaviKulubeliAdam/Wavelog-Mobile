enum ActivityType {
  dx,
  pota,
  sota,
  wwff,
  iota;

  String get label {
    switch (this) {
      case pota: return 'POTA';
      case sota: return 'SOTA';
      case wwff: return 'WWFF';
      case iota: return 'IOTA';
      case dx:   return 'DX';
    }
  }

  String get fullName {
    switch (this) {
      case pota: return 'Parks on the Air';
      case sota: return 'Summits on the Air';
      case wwff: return 'World Wild Flora & Fauna';
      case iota: return 'Islands on the Air';
      case dx:   return 'DX Cluster';
    }
  }

  String get icon {
    switch (this) {
      case pota: return '🌲';
      case sota: return '⛰️';
      case wwff: return '🌿';
      case iota: return '🏝️';
      case dx:   return '📡';
    }
  }

  String get refFormat {
    switch (this) {
      case pota: return 'PL-0001';
      case sota: return 'SP/TK-001';
      case wwff: return 'SPFF-0001';
      case iota: return 'EU-061';
      case dx:   return '';
    }
  }

  String get refLabel {
    switch (this) {
      case pota: return 'Park Reference';
      case sota: return 'Summit Reference';
      case wwff: return 'WWFF Reference';
      case iota: return 'IOTA Reference';
      case dx:   return '';
    }
  }

  /// Spot list is available for this activity type
  bool get available =>
      this == ActivityType.pota ||
      this == ActivityType.sota ||
      this == ActivityType.wwff ||
      this == ActivityType.dx;

  /// Add Spot feature is implemented
  bool get canAddSpot =>
      this == ActivityType.pota || this == ActivityType.sota;
}
