import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../models/qso_model.dart';

class QsoCacheDatasource {
  static const _boxName = 'qso_cache';
  static const _uuid = Uuid();

  Box<QsoModel> get _box => Hive.box<QsoModel>(_boxName);

  Future<void> cacheQsos(List<QsoModel> qsos) async {
    final toWrite = <String, QsoModel>{};
    for (final qso in qsos) {
      final key = qso.localId ?? _uuid.v4();
      toWrite[key] = qso.localId != null ? qso : qso.copyWith(localId: key, synced: true);
    }
    if (toWrite.isNotEmpty) {
      await _box.putAll(toWrite);
    }
  }

  Future<List<QsoModel>> getCachedQsos({
    int? stationId,
    String? band,
    String? mode,
    String? callsign,
  }) async {
    // Önce filtrele, sonra (küçülen listeyi) sırala
    Iterable<QsoModel> qsos = _box.values;

    if (stationId != null) {
      qsos = qsos.where((q) => q.stationProfileId == stationId);
    }
    if (band != null && band.isNotEmpty) {
      final b = band.toLowerCase();
      qsos = qsos.where((q) => q.band.toLowerCase() == b);
    }
    if (mode != null && mode.isNotEmpty) {
      final m = mode.toLowerCase();
      qsos = qsos.where((q) => q.mode.toLowerCase() == m);
    }
    if (callsign != null && callsign.isNotEmpty) {
      final cs = callsign.toUpperCase();
      qsos = qsos.where((q) => q.callsign.toUpperCase().contains(cs));
    }

    final result = qsos.toList()
      ..sort((a, b) => b.dateTimeOn.compareTo(a.dateTimeOn));
    return result;
  }

  Future<String> saveLocalQso(QsoModel qso) async {
    final id = qso.localId ?? _uuid.v4();
    final localQso = qso.copyWith(localId: id);
    await _box.put(id, localQso);
    return id;
  }

  Future<List<QsoModel>> getUnsyncedQsos() async {
    return _box.values.where((q) => !q.synced).toList();
  }

  int getUnsyncedCount() => _box.values.where((q) => !q.synced).length;

  Future<void> markSynced(String localId) async {
    final qso = _box.get(localId);
    if (qso != null) {
      await _box.put(
        localId,
        qso.copyWith(synced: true, syncedAt: DateTime.now()),
      );
    }
  }

  Future<void> deleteQso(String localId) async {
    await _box.delete(localId);
  }

  Future<void> updateQso(String localId, QsoModel updated) async {
    await _box.put(localId, updated.copyWith(localId: localId));
  }

  /// Bir istasyonun senkron kayıtlarını [incoming] ile eşitler.
  /// Tam sil+yaz yerine fark tabanlı çalışır: değişmeyen kayıtlar diske
  /// yeniden yazılmaz, sunucuda artık olmayan senkron kayıtlar silinir.
  Future<void> replaceSyncedQsosForStation(
      int stationId, List<QsoModel> incoming) async {
    final incomingKeys = <String>{};
    final toWrite = <String, QsoModel>{};

    for (final qso in incoming) {
      final key = qso.localId ?? _uuid.v4();
      incomingKeys.add(key);
      final entry =
          qso.localId != null ? qso : qso.copyWith(localId: key, synced: true);
      final existing = _box.get(key);
      // İçerik aynıysa diske dokunma
      if (existing != null &&
          existing.synced == entry.synced &&
          mapEquals(existing.rawAdif, entry.rawAdif)) {
        continue;
      }
      toWrite[key] = entry;
    }

    // Sunucuda artık olmayan eski senkron kayıtlar
    final staleKeys = _box.keys.cast<String>().where((k) {
      if (incomingKeys.contains(k)) return false;
      final q = _box.get(k);
      return q != null && q.synced && q.stationProfileId == stationId;
    }).toList();

    if (staleKeys.isNotEmpty) await _box.deleteAll(staleKeys);
    if (toWrite.isNotEmpty) await _box.putAll(toWrite);
  }

  // ── Bekleyen sunucu silmeleri (çevrimdışı silinen QSO'lar) ───────────

  static const _pendingDeleteKey = 'wl_pending_qso_deletes';

  Future<void> addPendingDelete(int serverId, int stationProfileId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_pendingDeleteKey) ?? [];
    final entry = '$serverId:$stationProfileId';
    if (!list.contains(entry)) {
      list.add(entry);
      await prefs.setStringList(_pendingDeleteKey, list);
    }
  }

  Future<List<({int serverId, int stationProfileId})>>
      getPendingDeletes() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_pendingDeleteKey) ?? [];
    final result = <({int serverId, int stationProfileId})>[];
    for (final entry in list) {
      final parts = entry.split(':');
      if (parts.length != 2) continue;
      final id = int.tryParse(parts[0]);
      final station = int.tryParse(parts[1]);
      if (id != null && station != null) {
        result.add((serverId: id, stationProfileId: station));
      }
    }
    return result;
  }

  Future<Set<int>> getPendingDeleteServerIds() async {
    final deletes = await getPendingDeletes();
    return deletes.map((d) => d.serverId).toSet();
  }

  Future<void> removePendingDelete(int serverId, int stationProfileId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_pendingDeleteKey) ?? [];
    list.remove('$serverId:$stationProfileId');
    await prefs.setStringList(_pendingDeleteKey, list);
  }

  Future<void> clearCache() async {
    await _box.clear();
  }

  // Clears the Hive cache when the API token changes (e.g., v1→v2 migration).
  // Stored token is compared without hashing — it never leaves the device.
  static const _tokenKey = 'wl_cache_token';

  Future<void> clearIfTokenChanged(String currentToken) async {
    if (currentToken.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_tokenKey) ?? '';
    if (stored != currentToken) {
      await _box.clear();
      await prefs.setString(_tokenKey, currentToken);
    }
  }

  CacheStats computeStats() {
    final all = _box.values.toList();

    final uniqueCallsigns =
        all.map((q) => q.callsign.toUpperCase()).toSet().length;

    // Consecutive-day streak ending today (or yesterday if no QSOs today)
    final days = all
        .map((q) =>
            DateTime(q.dateTimeOn.year, q.dateTimeOn.month, q.dateTimeOn.day))
        .toSet();
    final now = DateTime.now();
    DateTime check = DateTime(now.year, now.month, now.day);
    int streak = 0;
    // If today has no QSOs, start from yesterday
    if (!days.contains(check)) {
      check = check.subtract(const Duration(days: 1));
    }
    while (days.contains(check)) {
      streak++;
      check = check.subtract(const Duration(days: 1));
    }

    final todayDate = DateTime(now.year, now.month, now.day);
    final todayQsos = all.where((q) {
      final local = q.dateTimeOn.toLocal();
      return DateTime(local.year, local.month, local.day) == todayDate;
    }).length;

    final byBand = <String, int>{};
    final byMode = <String, int>{};
    final byStation = <int, int>{};
    for (final q in all) {
      byBand[q.band] = (byBand[q.band] ?? 0) + 1;
      byMode[q.mode] = (byMode[q.mode] ?? 0) + 1;
      byStation[q.stationProfileId] =
          (byStation[q.stationProfileId] ?? 0) + 1;
    }

    return CacheStats(
      uniqueCallsigns: uniqueCallsigns,
      currentStreakDays: streak,
      todayQsos: todayQsos,
      byBand: byBand,
      byMode: byMode,
      byStation: byStation,
    );
  }

  /// Returns QSO count per POTA park reference, restricted to the given
  /// POTA station IDs. Falls back to [stationPotaRefs] when MY_POTA_REF
  /// is absent from the QSO's rawAdif.
  Map<String, int> computePotaQsosByPark(
    Set<int> potaStationIds,
    Map<int, String> stationPotaRefs,
  ) {
    final byPark = <String, int>{};
    for (final q in _box.values) {
      if (!potaStationIds.contains(q.stationProfileId)) continue;
      final raw = q.myPota?.trim();
      final ref = (raw != null && raw.isNotEmpty)
          ? raw
          : stationPotaRefs[q.stationProfileId];
      if (ref == null || ref.isEmpty) continue;
      // MY_POTA_REF can be comma-separated for multi-park activations
      for (final r in ref.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty)) {
        byPark[r] = (byPark[r] ?? 0) + 1;
      }
    }
    return byPark;
  }

  int get cachedCount => _box.length;
  int get unsyncedCount => _box.values.where((q) => !q.synced).length;
}

class CacheStats {
  final int uniqueCallsigns;
  final int currentStreakDays;
  final int todayQsos;
  final Map<String, int> byBand;
  final Map<String, int> byMode;
  final Map<int, int> byStation;

  const CacheStats({
    required this.uniqueCallsigns,
    required this.currentStreakDays,
    required this.todayQsos,
    required this.byBand,
    required this.byMode,
    required this.byStation,
  });
}
