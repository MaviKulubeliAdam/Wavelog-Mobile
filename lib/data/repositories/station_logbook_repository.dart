import '../datasources/remote/wavelog_remote_datasource.dart';
import '../models/station_logbook_model.dart';

class StationLogbookRepository {
  final WavelogRemoteDatasource _remote;

  StationLogbookRepository({required WavelogRemoteDatasource remote})
      : _remote = remote;

  Future<List<StationLogbookModel>> getLogbooks() => _remote.getLogbooks();

  Future<int> createLogbook(String name) => _remote.createLogbook(name);

  Future<void> updateLogbook(int logbookId, String name) =>
      _remote.updateLogbook(logbookId, name);

  Future<void> deleteLogbook(int logbookId) =>
      _remote.deleteLogbook(logbookId);

  Future<void> setActiveLogbook(int logbookId) =>
      _remote.setActiveLogbook(logbookId);

  Future<void> link(int logbookId, int stationId) =>
      _remote.linkStationToLogbook(logbookId, stationId);

  Future<void> unlink(int logbookId, int stationId) =>
      _remote.unlinkStationFromLogbook(logbookId, stationId);
}
