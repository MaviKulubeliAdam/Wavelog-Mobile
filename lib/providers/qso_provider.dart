import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/errors/app_exception.dart';
import '../data/models/qso_model.dart';
import 'remote_datasource_provider.dart';
import 'settings_provider.dart';
import 'station_provider.dart';
import 'statistics_provider.dart';

class QsoFilter {
  final String? band;
  final String? mode;
  final String? callsign;

  const QsoFilter({
    this.band,
    this.mode,
    this.callsign,
  });

  bool get hasFilters =>
      (band?.isNotEmpty ?? false) ||
      (mode?.isNotEmpty ?? false) ||
      (callsign?.isNotEmpty ?? false);

  // Use a private sentinel so callers can explicitly pass null to clear a field.
  static const _keep = Object();

  QsoFilter copyWith({
    Object? band = _keep,
    Object? mode = _keep,
    Object? callsign = _keep,
  }) {
    return QsoFilter(
      band: band == _keep ? this.band : band as String?,
      mode: mode == _keep ? this.mode : mode as String?,
      callsign: callsign == _keep ? this.callsign : callsign as String?,
    );
  }

  QsoFilter cleared() => const QsoFilter();
}

final qsoFilterProvider = StateProvider<QsoFilter>((ref) => const QsoFilter());

final qsoProvider =
    AsyncNotifierProvider<QsoNotifier, List<QsoModel>>(QsoNotifier.new);

// Filtrelenmiş görünüm — filtre/arama değişimi ağa çıkmaz, bellekte uygulanır.
// Eskiden her arama tuş vuruşu tüm istasyonlar için sunucudan tam yeniden
// çekim + Hive yeniden yazımı tetikliyordu.
final filteredQsoProvider = Provider<AsyncValue<List<QsoModel>>>((ref) {
  final raw = ref.watch(qsoProvider);
  final filter = ref.watch(qsoFilterProvider);
  if (!filter.hasFilters) return raw;

  return raw.whenData((qsos) {
    final band = filter.band?.toLowerCase();
    final mode = filter.mode?.toLowerCase();
    final callsign = filter.callsign?.toUpperCase();
    return qsos.where((q) {
      if (band != null && band.isNotEmpty &&
          q.band.toLowerCase() != band) {
        return false;
      }
      if (mode != null && mode.isNotEmpty &&
          q.mode.toLowerCase() != mode) {
        return false;
      }
      if (callsign != null && callsign.isNotEmpty &&
          !q.callsign.toUpperCase().contains(callsign)) {
        return false;
      }
      return true;
    }).toList();
  });
});

class QsoNotifier extends AsyncNotifier<List<QsoModel>> {
  @override
  Future<List<QsoModel>> build() async {
    final result = await _fetch();
    // recentQsoProvider does NOT watch qsoProvider (prevents CircularDependencyError).
    // Invalidate it explicitly after every build so the home screen stays fresh.
    Future.microtask(() {
      ref.invalidate(recentQsoProvider);
      ref.invalidate(logbookSummaryProvider);
    });
    return result;
  }

  Future<List<QsoModel>> _fetch() async {
    final settings = ref.read(settingsProvider);
    final repo = ref.read(qsoRepositoryProvider);

    // Çevrimdışıyken kaydedilen/silinen QSO'ları sunucuya ilet.
    // Başarısız olursa liste yine de yüklenmeli.
    if (!settings.offlineModeEnabled) {
      try {
        await repo.syncPendingQsos();
      } catch (_) {}
    }

    // Get all stations and fetch QSOs for each
    final stations = await ref.read(stationProvider.future);
    if (stations.isEmpty) return [];

    final futures = stations.map((s) => repo
        .fetchQsos(
          stationId: s.id,
          forceLocal: settings.offlineModeEnabled,
        )
        .catchError((_) => <QsoModel>[]));

    final results = await Future.wait(futures);
    final seen = <String>{};
    final all = results
        .expand((list) => list)
        .where((q) => q.localId == null || seen.add(q.localId!))
        .toList();

    // Sort by date descending (newest first)
    all.sort((a, b) {
      final da = a.dateTimeOn;
      final db = b.dateTimeOn;
      return db.compareTo(da);
    });

    return all;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
    ref.invalidate(recentQsoProvider);
    ref.invalidate(logbookSummaryProvider);
  }

  // Returns true if saved to server, false if saved locally only (network failure)
  Future<bool> addQso(QsoModel qso, {bool forceLocal = false}) async {
    final repo = ref.read(qsoRepositoryProvider);
    bool savedToServer = !forceLocal;

    try {
      await repo.addQso(qso, forceLocal: forceLocal);
    } on NetworkException {
      // Repository already saved locally — treat as success, not an error
      savedToServer = false;
    }

    final savedQso = qso.copyWith(synced: savedToServer);

    // Show new QSO immediately without a loading flash
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data([savedQso, ...current]);

    // Invalidate home screen providers so stats/recent list update
    ref.invalidate(recentQsoProvider);
    ref.invalidate(statisticsProvider);
    ref.invalidate(logbookSummaryProvider);

    // Silently re-fetch in background to get server-assigned fields
    if (savedToServer) {
      _fetch().then((fresh) => state = AsyncValue.data(fresh), onError: (_) {});
    }

    return savedToServer;
  }

  Future<void> deleteQso(QsoModel qso) async {
    // Optimistic removal from UI
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data(
      current.where((q) => q.localId != qso.localId).toList(),
    );
    await ref.read(qsoRepositoryProvider).deleteQso(qso);
    ref.invalidate(recentQsoProvider);
    ref.invalidate(statisticsProvider);
    ref.invalidate(logbookSummaryProvider);
  }

  Future<bool> updateQso(QsoModel original, QsoModel updated,
      {bool forceLocal = false}) async {
    final repo = ref.read(qsoRepositoryProvider);
    bool savedOnline;
    try {
      savedOnline =
          await repo.updateQso(original, updated, forceLocal: forceLocal);
    } on NetworkException {
      savedOnline = false;
    }

    final updatedQso = updated.copyWith(
      localId: original.localId,
      synced: savedOnline,
    );

    final current = state.valueOrNull ?? [];
    state = AsyncValue.data(
      current
          .map((q) => q.localId == original.localId ? updatedQso : q)
          .toList(),
    );

    ref.invalidate(recentQsoProvider);
    ref.invalidate(statisticsProvider);
    ref.invalidate(logbookSummaryProvider);

    return savedOnline;
  }

  void applyFilter(QsoFilter filter) {
    ref.read(qsoFilterProvider.notifier).state = filter;
  }

  void clearFilter() {
    ref.read(qsoFilterProvider.notifier).state = const QsoFilter();
  }
}

// Previous QSOs with a specific callsign — used by the tablet add-QSO side panel.
final previousQsosByCallsignProvider =
    FutureProvider.family<List<QsoModel>, String>((ref, callsign) async {
  if (callsign.length < 3) return [];
  final cache = ref.read(qsoCacheDatasourceProvider);
  final all = await cache.getCachedQsos();
  final cs = callsign.toUpperCase();
  return all.where((q) => q.callsign.toUpperCase() == cs).toList();
});

// Quick list for home screen — reads from Hive cache.
// Does NOT watch qsoProvider — that caused CircularDependencyError when
// addQso() changed state and then invalidated this provider in the same tick.
// QsoNotifier invalidates it explicitly after every state change instead.
final recentQsoProvider = FutureProvider<List<QsoModel>>((ref) async {
  final cache = ref.read(qsoCacheDatasourceProvider);
  final all = await cache.getCachedQsos();
  return all.take(20).toList();
});

// Son 5 QSO + bugünün sayacı — add QSO ekranında kullanılır.
// KASITLI OLARAK qsoProvider'ı izlemiyor: QsoNotifier.addQso() zaten bu
// provider'ı invalidate ediyor, dolayısıyla döngüsel bağımlılık oluşmaz.
final logbookSummaryProvider =
    FutureProvider<({List<QsoModel> last5, int todayCount})>((ref) async {
  final cache = ref.read(qsoCacheDatasourceProvider);
  final all = await cache.getCachedQsos();
  final now = DateTime.now();
  final todayCount = all.where((q) {
    final d = q.dateTimeOn.toLocal();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }).length;
  return (last5: all.take(5).toList(), todayCount: todayCount);
});
