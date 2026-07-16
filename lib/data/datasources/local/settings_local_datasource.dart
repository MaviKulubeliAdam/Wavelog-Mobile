import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/settings_model.dart';

class SettingsLocalDatasource {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  // Secure keys — API key and server URL are stored in encrypted storage
  static const _keyServerUrl = 'wl_server_url';
  static const _keyApiKey    = 'wl_api_key';

  // Non-sensitive keys — stored in SharedPreferences
  static const _keyActiveProfileId       = 'wl_active_profile_id';
  static const _keyActiveStationId       = 'wl_active_station_id';
  static const _keyActiveStationCallsign = 'wl_active_station_callsign';
  static const _keyActiveStationName     = 'wl_active_station_name';
  static const _keyActiveLogbookId       = 'wl_active_logbook_id';
  static const _keyDefaultBand           = 'wl_default_band';
  static const _keyDefaultMode           = 'wl_default_mode';
  static const _keyDarkTheme             = 'wl_dark_theme';
  static const _keyOfflineMode           = 'wl_offline_mode';
  static const _keyPotaAutoSpot         = 'wl_pota_auto_spot';
  static const _keyLocale                = 'wl_locale';

  Future<SettingsModel> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Read sensitive fields from secure storage
    var serverUrl = await _storage.read(key: _keyServerUrl) ?? '';
    var apiKey    = await _storage.read(key: _keyApiKey)    ?? '';

    // One-time migration: move credentials from SharedPreferences to secure storage
    if (serverUrl.isEmpty) {
      final legacy = prefs.getString(_keyServerUrl) ?? '';
      if (legacy.isNotEmpty) {
        serverUrl = legacy;
        await _storage.write(key: _keyServerUrl, value: serverUrl);
        await prefs.remove(_keyServerUrl);
      }
    }
    if (apiKey.isEmpty) {
      final legacy = prefs.getString(_keyApiKey) ?? '';
      if (legacy.isNotEmpty) {
        apiKey = legacy;
        await _storage.write(key: _keyApiKey, value: apiKey);
        await prefs.remove(_keyApiKey);
      }
    }

    return SettingsModel(
      serverUrl:              serverUrl,
      apiKey:                 apiKey,
      activeProfileId:        prefs.getString(_keyActiveProfileId),
      activeStationProfileId: prefs.getInt(_keyActiveStationId),
      activeStationCallsign:  prefs.getString(_keyActiveStationCallsign),
      activeStationName:      prefs.getString(_keyActiveStationName),
      activeLogbookId:        prefs.getInt(_keyActiveLogbookId),
      defaultBand:            prefs.getString(_keyDefaultBand) ?? '20m',
      defaultMode:            prefs.getString(_keyDefaultMode) ?? 'SSB',
      darkTheme:              prefs.getBool(_keyDarkTheme) ?? true,
      offlineModeEnabled:     prefs.getBool(_keyOfflineMode) ?? false,
      potaAutoSpotEnabled:    prefs.getBool(_keyPotaAutoSpot) ?? false,
      locale:                 prefs.getString(_keyLocale),
    );
  }

  Future<void> saveSettings(SettingsModel settings) async {
    final prefs = await SharedPreferences.getInstance();

    // Sensitive fields → encrypted secure storage
    await _storage.write(key: _keyServerUrl, value: settings.serverUrl);
    await _storage.write(key: _keyApiKey,    value: settings.apiKey);

    // Non-sensitive fields → SharedPreferences
    if (settings.activeProfileId != null) {
      await prefs.setString(_keyActiveProfileId, settings.activeProfileId!);
    } else {
      await prefs.remove(_keyActiveProfileId);
    }
    if (settings.activeStationProfileId != null) {
      await prefs.setInt(_keyActiveStationId, settings.activeStationProfileId!);
    } else {
      await prefs.remove(_keyActiveStationId);
    }
    if (settings.activeStationCallsign != null) {
      await prefs.setString(
          _keyActiveStationCallsign, settings.activeStationCallsign!);
    } else {
      await prefs.remove(_keyActiveStationCallsign);
    }
    if (settings.activeStationName != null) {
      await prefs.setString(_keyActiveStationName, settings.activeStationName!);
    } else {
      await prefs.remove(_keyActiveStationName);
    }
    if (settings.activeLogbookId != null) {
      await prefs.setInt(_keyActiveLogbookId, settings.activeLogbookId!);
    } else {
      await prefs.remove(_keyActiveLogbookId);
    }
    await prefs.setString(_keyDefaultBand, settings.defaultBand);
    await prefs.setString(_keyDefaultMode, settings.defaultMode);
    await prefs.setBool(_keyDarkTheme, settings.darkTheme);
    await prefs.setBool(_keyOfflineMode, settings.offlineModeEnabled);
    await prefs.setBool(_keyPotaAutoSpot, settings.potaAutoSpotEnabled);
    if (settings.locale != null) {
      await prefs.setString(_keyLocale, settings.locale!);
    } else {
      await prefs.remove(_keyLocale);
    }
  }

  Future<bool> hasValidConfig() async {
    final settings = await loadSettings();
    return settings.hasValidConfig;
  }

  Future<List<String>> getLookupHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('wl_lookup_history') ?? [];
  }

  Future<void> addToLookupHistory(String callsign) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('wl_lookup_history') ?? [];
    history.remove(callsign.toUpperCase());
    history.insert(0, callsign.toUpperCase());
    if (history.length > 10) history.removeLast();
    await prefs.setStringList('wl_lookup_history', history);
  }

  Future<void> clearLookupHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('wl_lookup_history');
  }

  Future<String?> getLastFreq() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('wl_last_freq');
  }

  Future<void> saveLastFreq(String freq) async {
    if (freq.trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('wl_last_freq', freq.trim());
  }
}
