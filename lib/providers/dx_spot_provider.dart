import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasources/remote/dx_cluster_datasource.dart';
import '../data/models/dx_spot_model.dart';

final _dxDatasourceProvider =
    Provider<DxClusterDatasource>((_) => DxClusterDatasource());

final dxSpotsProvider = FutureProvider<List<DxSpotModel>>((ref) async {
  return ref.read(_dxDatasourceProvider).getSpots();
});

class DxSpotFilter {
  final String? band;
  final String? mode;
  final bool newestFirst;

  const DxSpotFilter({
    this.band,
    this.mode,
    this.newestFirst = true,
  });

  bool get hasFilters => band != null || mode != null;

  DxSpotFilter copyWith({
    Object? band = _s,
    Object? mode = _s,
    bool? newestFirst,
  }) =>
      DxSpotFilter(
        band: band == _s ? this.band : band as String?,
        mode: mode == _s ? this.mode : mode as String?,
        newestFirst: newestFirst ?? this.newestFirst,
      );

  static const _s = Object();
}

final dxSpotFilterProvider =
    StateProvider<DxSpotFilter>((_) => const DxSpotFilter());

final filteredDxSpotsProvider =
    Provider<AsyncValue<List<DxSpotModel>>>((ref) {
  final raw = ref.watch(dxSpotsProvider);
  final filter = ref.watch(dxSpotFilterProvider);

  return raw.whenData((spots) {
    var result = spots.where((s) {
      if (filter.band != null && s.band != filter.band) return false;
      if (filter.mode != null && s.mode != filter.mode) return false;
      return true;
    }).toList();

    if (!filter.newestFirst) result = result.reversed.toList();
    return result;
  });
});
