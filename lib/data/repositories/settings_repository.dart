import '../datasources/local/settings_local_datasource.dart';
import '../datasources/remote/wavelog_remote_datasource.dart';
import '../models/settings_model.dart';

class ConnectionTestResult {
  final bool success;
  final String? message;
  final int? totalQsos;

  const ConnectionTestResult({
    required this.success,
    this.message,
    this.totalQsos,
  });
}

class SettingsRepository {
  final SettingsLocalDatasource _local;

  SettingsRepository({required SettingsLocalDatasource local}) : _local = local;

  Future<SettingsModel> loadSettings() => _local.loadSettings();

  Future<void> saveSettings(SettingsModel settings) =>
      _local.saveSettings(settings);

  Future<bool> hasValidConfig() => _local.hasValidConfig();

  Future<ConnectionTestResult> testConnection(
      WavelogRemoteDatasource remote) async {
    final stats = await remote.getStatistics();
    final version = await remote.getVersion();
    return ConnectionTestResult(
      success: true,
      message: version != null ? 'Wavelog v$version' : null,
      totalQsos: stats.totalQsos,
    );
  }

}
