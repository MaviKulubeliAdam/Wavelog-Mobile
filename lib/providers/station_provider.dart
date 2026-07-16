import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/dxcc_entity_model.dart';
import '../data/models/state_subdivision_model.dart';
import '../data/models/station_model.dart';
import 'remote_datasource_provider.dart';
import 'settings_provider.dart';

final stationProvider =
    AsyncNotifierProvider<StationNotifier, List<StationModel>>(
        StationNotifier.new);

class StationNotifier extends AsyncNotifier<List<StationModel>> {
  @override
  Future<List<StationModel>> build() async {
    return _fetchStations();
  }

  Future<List<StationModel>> _fetchStations() async {
    final repo = ref.read(stationRepositoryProvider);
    final stations = await repo.getStations();

    // Sunucunun aktif istasyonunu yerel ayarla eşitle
    final serverActive = stations.where((s) => s.isActive).firstOrNull;
    if (serverActive != null) {
      final localActiveId = ref.read(settingsProvider).activeStationProfileId;
      if (localActiveId != serverActive.id) {
        await ref.read(settingsProvider.notifier).setActiveStation(serverActive);
      }
    }

    return stations;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchStations);
  }

  Future<bool> createStation(StationModel station,
      {bool linkActiveLogbook = false}) async {
    try {
      final repo = ref.read(stationRepositoryProvider);
      await repo.createStation(station, linkActiveLogbook: linkActiveLogbook);
      await refresh();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<StationModel?> getStationDetail(int stationId) async {
    try {
      final repo = ref.read(stationRepositoryProvider);
      return await repo.getStationDetail(stationId);
    } catch (_) {
      return null;
    }
  }

  Future<String?> updateStation(StationModel station) async {
    try {
      final repo = ref.read(stationRepositoryProvider);
      await repo.updateStation(station);
      await refresh();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> deleteStation(int stationId) async {
    try {
      final repo = ref.read(stationRepositoryProvider);
      await repo.deleteStation(stationId);
      await refresh();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> cloneStation(StationModel station, String newName) async {
    try {
      final repo = ref.read(stationRepositoryProvider);
      await repo.cloneStation(station.id, newName);
      await refresh();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<DxccEntity>> getDxccList() async {
    final repo = ref.read(stationRepositoryProvider);
    return repo.getDxccList();
  }

  Future<List<StateSubdivision>> getStateList(int dxcc) async {
    final repo = ref.read(stationRepositoryProvider);
    return repo.getStateList(dxcc);
  }
}
