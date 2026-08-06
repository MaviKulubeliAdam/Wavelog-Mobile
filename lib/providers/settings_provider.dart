import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasources/local/settings_local_datasource.dart';
import '../data/models/settings_model.dart';
import '../data/models/station_model.dart';
import '../data/models/user_profile_model.dart';
import '../data/repositories/settings_repository.dart';

final settingsLocalDatasourceProvider =
    Provider<SettingsLocalDatasource>((ref) => SettingsLocalDatasource());

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(
    local: ref.watch(settingsLocalDatasourceProvider),
  );
});

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsModel>((ref) {
  return SettingsNotifier(ref.watch(settingsRepositoryProvider));
});

class SettingsNotifier extends StateNotifier<SettingsModel> {
  final SettingsRepository _repo;
  final Completer<void> _ready = Completer<void>();

  // Awaitable — resolves once SharedPreferences settings are loaded
  Future<void> get whenLoaded => _ready.future;

  SettingsNotifier(this._repo) : super(const SettingsModel()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final s = await _repo.loadSettings();
      state = s;
    } catch (_) {
      // Güvenli depolama bazı cihazlarda fırlatabilir — varsayılan ayarlarla
      // devam et; aksi hâlde splash sonsuza dek bekler.
    } finally {
      if (!_ready.isCompleted) _ready.complete();
    }
  }

  Future<void> update(SettingsModel newSettings) async {
    await _repo.saveSettings(newSettings);
    state = newSettings;
  }

  Future<void> updateServerUrl(String url) async {
    final s = state.copyWith(serverUrl: url.trimRight().replaceAll(RegExp(r'/+$'), ''));
    await _repo.saveSettings(s);
    state = s;
  }

  Future<void> updateApiKey(String key) async {
    final s = state.copyWith(apiKey: key.trim());
    await _repo.saveSettings(s);
    state = s;
  }

  Future<void> setActiveStation(StationModel station) async {
    final s = state.copyWith(
      activeStationProfileId: station.id,
      activeStationCallsign: station.callsign,
      activeStationName: station.profileName,
    );
    await _repo.saveSettings(s);
    state = s;
  }

  Future<void> setActiveLogbook(int logbookId) async {
    final s = state.copyWith(activeLogbookId: logbookId);
    await _repo.saveSettings(s);
    state = s;
  }

  Future<void> setDefaultBand(String band) async {
    final s = state.copyWith(defaultBand: band);
    await _repo.saveSettings(s);
    state = s;
  }

  Future<void> setDefaultMode(String mode) async {
    final s = state.copyWith(defaultMode: mode);
    await _repo.saveSettings(s);
    state = s;
  }

  Future<void> setDarkTheme(bool value) async {
    final s = state.copyWith(darkTheme: value);
    await _repo.saveSettings(s);
    state = s;
  }

  Future<void> setOfflineMode(bool value) async {
    final s = state.copyWith(offlineModeEnabled: value);
    await _repo.saveSettings(s);
    state = s;
  }

  Future<void> setPotaAutoSpot(bool value) async {
    final s = state.copyWith(potaAutoSpotEnabled: value);
    await _repo.saveSettings(s);
    state = s;
  }

  Future<void> setNavStyle({required bool modern}) async {
    final s = state.copyWith(useModernNav: modern);
    await _repo.saveSettings(s);
    state = s;
  }

  Future<void> setLocale(String? locale) async {
    final s = locale == null
        ? state.copyWith(clearLocale: true)
        : state.copyWith(locale: locale);
    await _repo.saveSettings(s);
    state = s;
  }

  Future<void> loginWithProfile(
      UserProfileModel profile, StationModel? autoStation) async {
    final s = SettingsModel(
      serverUrl: state.serverUrl,
      apiKey: profile.apiKey,
      activeProfileId: profile.id,
      activeStationProfileId: autoStation?.id,
      activeStationCallsign: autoStation?.callsign ?? profile.callsign,
      activeStationName: autoStation?.profileName,
      defaultBand: state.defaultBand,
      defaultMode: state.defaultMode,
      darkTheme: state.darkTheme,
      offlineModeEnabled: state.offlineModeEnabled,
      locale: state.locale,
    );
    await _repo.saveSettings(s);
    state = s;
  }

  Future<void> logout() async {
    final s = SettingsModel(
      serverUrl: state.serverUrl,
      defaultBand: state.defaultBand,
      defaultMode: state.defaultMode,
      darkTheme: state.darkTheme,
      offlineModeEnabled: state.offlineModeEnabled,
      locale: state.locale,
    );
    await _repo.saveSettings(s);
    state = s;
  }
}
