import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/statistics_model.dart';
import 'remote_datasource_provider.dart';

final statisticsProvider = FutureProvider<StatisticsModel>((ref) async {
  final remote = ref.watch(wavelogRemoteDatasourceProvider);
  return remote.getStatistics();
});
