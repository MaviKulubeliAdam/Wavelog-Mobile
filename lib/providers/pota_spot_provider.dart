import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasources/remote/pota_datasource.dart';
import '../data/models/pota_spot_model.dart';

final _potaDatasourceProvider = Provider<PotaDatasource>((_) => PotaDatasource());

// Raw spots from API
final potaSpotsProvider = FutureProvider<List<PotaSpotModel>>((ref) async {
  return ref.read(_potaDatasourceProvider).getSpots();
});

// Active filter state
final potaSpotFilterProvider =
    StateProvider<PotaSpotFilter>((_) => const PotaSpotFilter());

// Filtered + sorted spots derived from raw + filter
final filteredPotaSpotsProvider = Provider<AsyncValue<List<PotaSpotModel>>>((ref) {
  final raw = ref.watch(potaSpotsProvider);
  final filter = ref.watch(potaSpotFilterProvider);

  return raw.whenData((spots) {
    var result = spots.where((s) {
      if (filter.band != null && s.band != filter.band) return false;
      if (filter.mode != null && s.mode != filter.mode) return false;
      if (filter.country != null && s.countryPrefix != filter.country) return false;
      return true;
    }).toList();

    if (!filter.newestFirst) result = result.reversed.toList();
    return result;
  });
});

// Add spot action
final addPotaSpotProvider = Provider<Future<void> Function({
  required String activator,
  required String spotter,
  required String frequency,
  required String mode,
  required String reference,
  String comments,
})>((ref) {
  return ({
    required String activator,
    required String spotter,
    required String frequency,
    required String mode,
    required String reference,
    String comments = '',
  }) async {
    await ref.read(_potaDatasourceProvider).addSpot(
          activator: activator,
          spotter: spotter,
          frequency: frequency,
          mode: mode,
          reference: reference,
          comments: comments,
        );
    ref.invalidate(potaSpotsProvider);
  };
});
