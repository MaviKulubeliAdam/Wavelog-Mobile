import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasources/remote/sota_datasource.dart';
import '../data/models/sota_spot_model.dart';

final _sotaDatasourceProvider =
    Provider<SotaDatasource>((_) => SotaDatasource());

final addSotaSpotProvider = Provider<Future<void> Function({
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
    await ref.read(_sotaDatasourceProvider).postSpot(
          activatorCallsign: activator,
          summitCode: reference,
          frequency: frequency,
          mode: mode,
          spotter: spotter,
          comments: comments,
        );
    ref.invalidate(sotaSpotsProvider);
  };
});

final sotaSpotsProvider = FutureProvider<List<SotaSpotModel>>((ref) async {
  return ref.read(_sotaDatasourceProvider).getSpots();
});

final sotaSpotFilterProvider =
    StateProvider<SotaSpotFilter>((_) => const SotaSpotFilter());

final filteredSotaSpotsProvider =
    Provider<AsyncValue<List<SotaSpotModel>>>((ref) {
  final raw = ref.watch(sotaSpotsProvider);
  final filter = ref.watch(sotaSpotFilterProvider);

  return raw.whenData((spots) {
    var result = spots.where((s) {
      if (filter.band != null && s.band != filter.band) return false;
      if (filter.mode != null && s.mode != filter.mode) return false;
      if (filter.association != null &&
          s.associationCode != filter.association) { return false; }
      return true;
    }).toList();

    if (!filter.newestFirst) result = result.reversed.toList();
    return result;
  });
});
