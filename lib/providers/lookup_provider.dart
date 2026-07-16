import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/callsign_lookup_model.dart';
import 'remote_datasource_provider.dart';

// Lightweight per-callsign lookup used by QSO detail screen.
// Does NOT write to history — use the full lookupProvider for that.
final callsignInfoProvider =
    FutureProvider.family<CallsignLookupModel, String>((ref, callsign) async {
  final remote = ref.read(wavelogRemoteDatasourceProvider);
  return remote.lookupCallsign(callsign: callsign.toUpperCase().trim());
});

final lookupHistoryProvider = FutureProvider<List<String>>((ref) async {
  final repo = ref.watch(lookupRepositoryProvider);
  return repo.getHistory();
});


final lookupProvider =
    AsyncNotifierProvider<LookupNotifier, CallsignLookupModel?>(
        LookupNotifier.new);

class LookupNotifier extends AsyncNotifier<CallsignLookupModel?> {
  @override
  Future<CallsignLookupModel?> build() async => null;

  Future<void> lookup(String callsign,
      {String? band, String? mode}) async {
    if (callsign.trim().isEmpty) return;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(lookupRepositoryProvider);
      final result = await repo.lookupCallsign(
        callsign: callsign.toUpperCase().trim(),
        band: band,
        mode: mode,
      );
      ref.invalidate(lookupHistoryProvider);
      return result;
    });
  }

  void clear() {
    state = const AsyncValue.data(null);
  }
}
