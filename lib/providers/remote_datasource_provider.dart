import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasources/local/qso_cache_datasource.dart';
import '../data/datasources/remote/wavelog_remote_datasource.dart';
import '../data/repositories/lookup_repository.dart';
import '../data/repositories/qso_repository.dart';
import '../data/repositories/station_logbook_repository.dart';
import '../data/repositories/station_repository.dart';
import 'dio_provider.dart';
import 'settings_provider.dart';

final qsoCacheDatasourceProvider =
    Provider<QsoCacheDatasource>((ref) => QsoCacheDatasource());

final wavelogRemoteDatasourceProvider =
    Provider<WavelogRemoteDatasource>((ref) {
  return WavelogRemoteDatasource(dio: ref.watch(dioProvider));
});

final qsoRepositoryProvider = Provider<QsoRepository>((ref) {
  return QsoRepository(
    remote: ref.watch(wavelogRemoteDatasourceProvider),
    local: ref.watch(qsoCacheDatasourceProvider),
  );
});

final stationRepositoryProvider = Provider<StationRepository>((ref) {
  return StationRepository(
    remote: ref.watch(wavelogRemoteDatasourceProvider),
  );
});

final stationLogbookRepositoryProvider =
    Provider<StationLogbookRepository>((ref) {
  return StationLogbookRepository(
    remote: ref.watch(wavelogRemoteDatasourceProvider),
  );
});

final lookupRepositoryProvider = Provider<LookupRepository>((ref) {
  return LookupRepository(
    remote: ref.watch(wavelogRemoteDatasourceProvider),
    local: ref.watch(settingsLocalDatasourceProvider),
  );
});
