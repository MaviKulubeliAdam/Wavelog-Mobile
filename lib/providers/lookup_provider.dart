import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/callsign_lookup_model.dart';
import 'remote_datasource_provider.dart';

// ── QSL status derived from the local QSO cache for a given callsign ─────────

class CallsignQslStatus {
  /// True if any QSO with this callsign has the given field == 'Y'.
  final bool qslSent;
  final bool qslRcvd;
  final bool lotwSent;
  final bool lotwRcvd;
  final bool eqslSent;
  final bool eqslRcvd;
  final bool qrzUploaded;

  bool get hasAny =>
      qslSent || qslRcvd || lotwSent || lotwRcvd || eqslSent || eqslRcvd || qrzUploaded;

  const CallsignQslStatus({
    this.qslSent = false,
    this.qslRcvd = false,
    this.lotwSent = false,
    this.lotwRcvd = false,
    this.eqslSent = false,
    this.eqslRcvd = false,
    this.qrzUploaded = false,
  });
}

final callsignQslStatusProvider =
    FutureProvider.family<CallsignQslStatus, String>((ref, callsign) async {
  if (callsign.length < 3) return const CallsignQslStatus();
  final cache = ref.read(qsoCacheDatasourceProvider);
  final all = await cache.getCachedQsos();
  final cs = callsign.toUpperCase();
  final qsos = all.where((q) => q.callsign.toUpperCase() == cs);

  bool isY(String? v) => v == 'Y';

  var qslSent    = false;
  var qslRcvd    = false;
  var lotwSent   = false;
  var lotwRcvd   = false;
  var eqslSent   = false;
  var eqslRcvd   = false;
  var qrzUploaded = false;

  for (final q in qsos) {
    final r = q.rawAdif ?? {};
    if (isY(r['QSL_SENT']))  qslSent    = true;
    if (isY(r['QSL_RCVD']))  qslRcvd    = true;
    if (isY(r['LOTW_QSL_SENT'])) lotwSent = true;
    if (isY(r['LOTW_QSL_RCVD'])) lotwRcvd = true;
    if (isY(r['EQSL_QSL_SENT'])) eqslSent = true;
    if (isY(r['EQSL_QSL_RCVD'])) eqslRcvd = true;
    final qrzStatus = r['QRZCOM_QSO_UPLOAD_STATUS'] ?? '';
    if (qrzStatus == 'Y' || qrzStatus == 'Complete') qrzUploaded = true;
  }

  return CallsignQslStatus(
    qslSent: qslSent,
    qslRcvd: qslRcvd,
    lotwSent: lotwSent,
    lotwRcvd: lotwRcvd,
    eqslSent: eqslSent,
    eqslRcvd: eqslRcvd,
    qrzUploaded: qrzUploaded,
  );
});

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
