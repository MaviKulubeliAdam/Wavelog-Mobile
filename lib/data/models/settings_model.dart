class SettingsModel {
  final String serverUrl;
  final String apiKey;
  final String? activeProfileId;
  final int? activeStationProfileId;
  final String? activeStationCallsign;
  final String? activeStationName;
  final int? activeLogbookId;
  final String defaultBand;
  final String defaultMode;
  final bool darkTheme;
  final bool offlineModeEnabled;
  final bool potaAutoSpotEnabled;
  final String? locale;

  const SettingsModel({
    this.serverUrl = '',
    this.apiKey = '',
    this.activeProfileId,
    this.activeStationProfileId,
    this.activeStationCallsign,
    this.activeStationName,
    this.activeLogbookId,
    this.defaultBand = '20m',
    this.defaultMode = 'SSB',
    this.darkTheme = true,
    this.offlineModeEnabled = false,
    this.potaAutoSpotEnabled = false,
    this.locale,
  });

  bool get hasValidConfig => serverUrl.isNotEmpty;

  bool get isLoggedIn =>
      serverUrl.isNotEmpty && activeProfileId != null && apiKey.isNotEmpty;

  SettingsModel copyWith({
    String? serverUrl,
    String? apiKey,
    String? activeProfileId,
    bool clearActiveProfile = false,
    int? activeStationProfileId,
    bool clearActiveStation = false,
    String? activeStationCallsign,
    String? activeStationName,
    int? activeLogbookId,
    bool clearActiveLogbook = false,
    String? defaultBand,
    String? defaultMode,
    bool? darkTheme,
    bool? offlineModeEnabled,
    bool? potaAutoSpotEnabled,
    String? locale,
    bool clearLocale = false,
  }) {
    return SettingsModel(
      serverUrl: serverUrl ?? this.serverUrl,
      apiKey: apiKey ?? this.apiKey,
      activeProfileId:
          clearActiveProfile ? null : (activeProfileId ?? this.activeProfileId),
      activeStationProfileId: clearActiveStation
          ? null
          : (activeStationProfileId ?? this.activeStationProfileId),
      activeStationCallsign: clearActiveStation
          ? null
          : (activeStationCallsign ?? this.activeStationCallsign),
      activeStationName: clearActiveStation
          ? null
          : (activeStationName ?? this.activeStationName),
      activeLogbookId: clearActiveLogbook
          ? null
          : (activeLogbookId ?? this.activeLogbookId),
      defaultBand: defaultBand ?? this.defaultBand,
      defaultMode: defaultMode ?? this.defaultMode,
      darkTheme: darkTheme ?? this.darkTheme,
      offlineModeEnabled: offlineModeEnabled ?? this.offlineModeEnabled,
      potaAutoSpotEnabled: potaAutoSpotEnabled ?? this.potaAutoSpotEnabled,
      locale: clearLocale ? null : (locale ?? this.locale),
    );
  }
}
