import '../datasources/remote/wavelog_remote_datasource.dart';
import '../models/dxcc_entity_model.dart';
import '../models/state_subdivision_model.dart';
import '../models/station_model.dart';

class StationRepository {
  final WavelogRemoteDatasource _remote;

  StationRepository({required WavelogRemoteDatasource remote})
      : _remote = remote;

  Future<List<StationModel>> getStations() => _remote.getStations();

  Future<StationModel> createStation(
          StationModel station, {bool linkActiveLogbook = false}) =>
      _remote.createStation(station, linkActiveLogbook: linkActiveLogbook);

  Future<StationModel> getStationDetail(int stationId) =>
      _remote.getStationDetail(stationId);

  Future<void> updateStation(StationModel station) =>
      _remote.updateStation(station);

  Future<void> deleteStation(int stationId) =>
      _remote.deleteStation(stationId);

  Future<int> cloneStation(int stationId, String newName) =>
      _remote.cloneStation(stationId, newName);

  Future<List<DxccEntity>> getDxccList() => _remote.getDxccList();

  Future<List<StateSubdivision>> getStateList(int dxcc) =>
      _remote.getStateList(dxcc);
}
