import '../datasources/local/settings_local_datasource.dart';
import '../datasources/remote/wavelog_remote_datasource.dart';
import '../models/callsign_lookup_model.dart';

class LookupRepository {
  final WavelogRemoteDatasource _remote;
  final SettingsLocalDatasource _local;

  LookupRepository({
    required WavelogRemoteDatasource remote,
    required SettingsLocalDatasource local,
  })  : _remote = remote,
        _local = local;

  Future<CallsignLookupModel> lookupCallsign({
    required String callsign,
    String? band,
    String? mode,
  }) async {
    final result = await _remote.lookupCallsign(
      callsign: callsign,
      band: band,
      mode: mode,
    );
    await _local.addToLookupHistory(callsign);
    return result;
  }

  Future<List<String>> getHistory() => _local.getLookupHistory();

  Future<void> clearHistory() => _local.clearLookupHistory();
}
