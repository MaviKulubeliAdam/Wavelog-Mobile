import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasources/remote/wwff_datasource.dart';
import '../data/models/wwff_spot_model.dart';

final _wwffDatasourceProvider =
    Provider<WwffDatasource>((_) => WwffDatasource());

final wwffSpotsProvider = FutureProvider<List<WwffSpotModel>>((ref) async {
  return ref.read(_wwffDatasourceProvider).getSpots();
});

final wwffSpotFilterProvider =
    StateProvider<WwffSpotFilter>((_) => const WwffSpotFilter());

final filteredWwffSpotsProvider =
    Provider<AsyncValue<List<WwffSpotModel>>>((ref) {
  final raw = ref.watch(wwffSpotsProvider);
  final filter = ref.watch(wwffSpotFilterProvider);

  return raw.whenData((spots) {
    var result = spots.where((s) {
      if (filter.band != null && s.band != filter.band) return false;
      if (filter.mode != null && s.mode != filter.mode) return false;
      if (filter.country != null && s.countryPrefix != filter.country) {
        return false;
      }
      return true;
    }).toList();

    if (!filter.newestFirst) result = result.reversed.toList();
    return result;
  });
});
