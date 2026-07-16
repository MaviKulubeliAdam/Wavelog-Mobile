import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasources/remote/solar_datasource.dart';
import '../data/models/solar_data_model.dart';

final _solarDatasourceProvider =
    Provider<SolarDatasource>((_) => SolarDatasource());

final solarDataProvider = FutureProvider<SolarDataModel>((ref) async {
  return ref.read(_solarDatasourceProvider).fetchSolarData();
});
