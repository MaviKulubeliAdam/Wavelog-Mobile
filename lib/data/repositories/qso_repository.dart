import 'package:flutter/foundation.dart';

import '../../core/errors/app_exception.dart';
import '../../core/utils/adif_generator.dart';
import '../../core/utils/adif_parser.dart';
import '../datasources/local/qso_cache_datasource.dart';
import '../datasources/remote/wavelog_remote_datasource.dart';
import '../models/qso_model.dart';

class ImportResult {
  final int total;
  final int imported;
  final int duplicates;
  final int errors;

  const ImportResult({
    required this.total,
    required this.imported,
    this.duplicates = 0,
    this.errors = 0,
  });
}

class QsoRepository {
  final WavelogRemoteDatasource _remote;
  final QsoCacheDatasource _local;

  QsoRepository({
    required WavelogRemoteDatasource remote,
    required QsoCacheDatasource local,
  })  : _remote = remote,
        _local = local;

  Future<List<QsoModel>> fetchQsos({
    required int stationId,
    String? band,
    String? mode,
    String? callsign,
    int fetchFromId = 0,
    bool forceLocal = false,
  }) async {
    if (forceLocal) {
      return _local.getCachedQsos(
          stationId: stationId, band: band, mode: mode, callsign: callsign);
    }

    try {
      final fetched = await _remote.getContacts(
        stationId: stationId,
        fetchFromId: fetchFromId,
        band: band,
      );
      // Çevrimdışı silinen (henüz sunucuya iletilmemiş) QSO'lar listede
      // yeniden belirmesin
      final pendingDeleteIds = await _local.getPendingDeleteServerIds();
      // Assign a deterministic localId to every server QSO so the
      // detail screen can always find it by ID.
      final remoteQsos = fetched
          .where((q) =>
              q.serverId == null || !pendingDeleteIds.contains(q.serverId))
          .map((q) => q.localId != null
              ? q
              : q.copyWith(localId: q.serverId?.toString() ?? _qsoId(q)))
          .toList();
      // Fark tabanlı önbellek eşitleme: değişmeyen kayıtlar yeniden
      // yazılmaz. Her istasyon kendi alt kümesini eşitlediği için paralel
      // fetchQsos çağrıları birbiriyle yarışmaz.
      await _local.replaceSyncedQsosForStation(stationId, remoteQsos);

      // Apply local filters
      if (mode != null || callsign != null) {
        return await _local.getCachedQsos(
            stationId: stationId, band: band, mode: mode, callsign: callsign);
      }
      return remoteQsos;
    } on NetworkException {
      return _local.getCachedQsos(
          stationId: stationId, band: band, mode: mode, callsign: callsign);
    } on TimeoutException {
      return _local.getCachedQsos(
          stationId: stationId, band: band, mode: mode, callsign: callsign);
    }
  }

  Future<void> addQso(QsoModel qso, {bool forceLocal = false}) async {
    if (forceLocal) {
      await _local.saveLocalQso(qso);
      return;
    }

    try {
      final adif = AdifGenerator.generateSingle(qso);
      final success = await _remote.importQso(adif, qso.stationProfileId);
      if (success) {
        await _local.saveLocalQso(qso.copyWith(synced: true));
      } else {
        throw const ServerException('QSO kaydedilemedi');
      }
    } on NetworkException {
      await _local.saveLocalQso(qso.copyWith(synced: false));
      rethrow;
    } on TimeoutException {
      // Zaman aşımı da ağ hatası gibi ele alınır — QSO kaybolmasın
      await _local.saveLocalQso(qso.copyWith(synced: false));
      rethrow;
    }
  }

  Future<ImportResult> importAdif(
      String adifContent, int stationProfileId) async {
    AdifParser.validate(adifContent);
    final records = AdifParser.parse(adifContent);
    final total = records.length;

    try {
      await _remote.importQso(adifContent, stationProfileId);
      final qsos = records
          .map((r) => AdifParser.mapToQso(r, stationProfileId)
              .copyWith(synced: true))
          .toList();
      await _local.cacheQsos(qsos);
      return ImportResult(total: total, imported: total);
    } catch (e) {
      return ImportResult(total: total, imported: 0, errors: total);
    }
  }

  // 50'lik partilerle import; her parti sonrası onProgress çağrılır
  Future<ImportResult> streamingImportAdif(
    String adifContent,
    int stationProfileId,
    void Function(int processed, int total) onProgress,
  ) async {
    AdifParser.validate(adifContent);
    final records = AdifParser.parse(adifContent);
    final total = records.length;
    const batchSize = 50;
    int imported = 0;
    int errors = 0;
    // Track which record indices succeeded so only those go into local cache.
    final successfulIndices = <int>[];

    for (var i = 0; i < total; i += batchSize) {
      final end = (i + batchSize).clamp(0, total);
      final batch = records.sublist(i, end);
      final batchAdif = AdifGenerator.fromParsedRecords(batch);
      try {
        await _remote.importQso(batchAdif, stationProfileId);
        for (var j = i; j < end; j++) {
          successfulIndices.add(j);
        }
        imported += batch.length;
      } catch (_) {
        errors += batch.length;
      }
      onProgress(imported + errors, total);
    }

    // Only cache records that the server accepted.
    if (successfulIndices.isNotEmpty) {
      final qsos = successfulIndices
          .map((i) => AdifParser.mapToQso(records[i], stationProfileId)
              .copyWith(synced: true))
          .toList();
      await _local.cacheQsos(qsos);
    }
    return ImportResult(total: total, imported: imported, errors: errors);
  }

  Future<List<QsoModel>> exportQsos({
    required int stationId,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    final qsos = await _remote.getContacts(stationId: stationId, fetchFromId: 0);
    return qsos.where((q) {
      final dt = q.dateTimeOn.toUtc();
      if (dateFrom != null && dt.isBefore(dateFrom.toUtc())) return false;
      if (dateTo != null) {
        final end = DateTime.utc(dateTo.year, dateTo.month, dateTo.day, 23, 59, 59);
        if (dt.isAfter(end)) return false;
      }
      return true;
    }).toList();
  }

  Future<String> exportAdif({
    required int stationId,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    final qsos = await exportQsos(stationId: stationId, dateFrom: dateFrom, dateTo: dateTo);
    return AdifGenerator.generate(qsos);
  }

  Future<void> deleteQso(QsoModel qso) async {
    if (qso.localId != null) {
      await _local.deleteQso(qso.localId!);
    }
    final id = qso.serverId;
    if (id != null) {
      try {
        await _remote.deleteQso(id, qso.stationProfileId);
      } catch (_) {
        // Herhangi bir hata (ağ, zaman aşımı, sunucu hatası) — kuyruğa al.
        // _processPendingDeletes, 404 gibi "zaten silindi" durumlarını
        // yakalayıp kuyruktan düşürür.
        await _local.addPendingDelete(id, qso.stationProfileId);
      }
    }
  }

  // Returns true if saved to server, false if local only
  Future<bool> updateQso(QsoModel original, QsoModel updated,
      {bool forceLocal = false}) async {
    final localId = original.localId;
    if (localId == null) throw const ServerException('QSO bulunamadı');

    if (forceLocal || !original.synced) {
      await _local.updateQso(localId, updated.copyWith(synced: false));
      return false;
    }

    final serverId = original.serverId;
    if (serverId == null) {
      await _local.updateQso(localId, updated.copyWith(synced: false));
      return false;
    }

    final fields = _buildUpdateFields(original, updated);
    if (fields.isEmpty) {
      await _local.updateQso(localId, updated.copyWith(synced: true));
      return true;
    }

    try {
      await _remote.updateQsoFields(serverId, updated.stationProfileId, fields);
      await _local.updateQso(localId, updated.copyWith(synced: true));
      return true;
    } on NetworkException {
      await _local.updateQso(localId, updated.copyWith(synced: false));
      return false;
    } on TimeoutException {
      await _local.updateQso(localId, updated.copyWith(synced: false));
      return false;
    }
  }

  // Build v2 API field map (flat JSON) with only changed values.
  // Field names match the v2 PATCH /api/v2/qso/{id} schema, not COL_* columns.
  static Map<String, dynamic> _buildUpdateFields(
      QsoModel original, QsoModel updated) {
    final f = <String, dynamic>{};

    if (original.callsign != updated.callsign) f['call'] = updated.callsign;
    if (original.band != updated.band) f['band'] = updated.band;
    if (original.freqMhz != updated.freqMhz) {
      // v2 PATCH expects Hz; send empty string to clear the field.
      f['freq'] = updated.freqMhz != null
          ? (updated.freqMhz! * 1000000).round().toString()
          : '';
    }
    // mode: v2 handles submode split internally; send submode value when present
    if (original.mode != updated.mode || original.submode != updated.submode) {
      f['mode'] = (updated.submode?.isNotEmpty == true)
          ? updated.submode!
          : updated.mode;
    }
    if (original.rstSent != updated.rstSent) f['rst_sent'] = updated.rstSent;
    if (original.rstRcvd != updated.rstRcvd) f['rst_rcvd'] = updated.rstRcvd;
    // date+time must travel together per v2 spec
    if (original.dateTimeOn != updated.dateTimeOn) {
      final dt = updated.dateTimeOn.toUtc();
      f['qso_date'] = _patchDate(dt); // YYYY-MM-DD
      f['time_on'] = _patchTime(dt);  // HHMMSS
    }
    if (original.name != updated.name) f['name'] = updated.name ?? '';
    if (original.qth != updated.qth) f['qth'] = updated.qth ?? '';
    if (original.gridSquare != updated.gridSquare) {
      f['gridsquare'] = updated.gridSquare ?? '';
    }
    if (original.comment != updated.comment) f['comment'] = updated.comment ?? '';
    if (original.notes != updated.notes) f['notes'] = updated.notes ?? '';

    // rawAdif-backed extension fields
    final oRaw = original.rawAdif ?? {};
    final uRaw = updated.rawAdif ?? {};
    const adifToV2 = {
      'TX_PWR': 'tx_pwr',
      'IOTA': 'iota',
      'SOTA_REF': 'sota_ref',
      'WWFF_REF': 'wwff_ref',
      'POTA_REF': 'pota_ref',
    };
    for (final entry in adifToV2.entries) {
      final oVal = oRaw[entry.key] ?? '';
      final uVal = uRaw[entry.key] ?? '';
      if (oVal != uVal) f[entry.value] = uVal;
    }

    return f;
  }

  // YYYY-MM-DD — v2 PATCH date format (strtotime-safe)
  static String _patchDate(DateTime dt) =>
      '${dt.year.toString().padLeft(4, '0')}-'
      '${dt.month.toString().padLeft(2, '0')}-'
      '${dt.day.toString().padLeft(2, '0')}';

  // HHMMSS — v2 PATCH time format
  static String _patchTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}'
      '${dt.minute.toString().padLeft(2, '0')}'
      '${dt.second.toString().padLeft(2, '0')}';

  Future<void> syncPendingQsos() async {
    await _processPendingDeletes();

    final pending = await _local.getUnsyncedQsos();
    if (pending.isEmpty) return;

    // Group by stationProfileId and batch
    final groups = <int, List<QsoModel>>{};
    for (final qso in pending) {
      groups.putIfAbsent(qso.stationProfileId, () => []).add(qso);
    }

    for (final entry in groups.entries) {
      final adif = AdifGenerator.generate(entry.value);
      try {
        final success = await _remote.importQso(adif, entry.key);
        if (success) {
          for (final qso in entry.value) {
            if (qso.localId != null) {
              await _local.markSynced(qso.localId!);
            }
          }
        }
      } catch (e) {
        debugPrint('Batch sync failed for group, will retry later: $e');
      }
    }
  }

  // Çevrimdışıyken silinen QSO'ların sunucu silmelerini işler
  Future<void> _processPendingDeletes() async {
    final deletes = await _local.getPendingDeletes();
    for (final d in deletes) {
      try {
        await _remote.deleteQso(d.serverId, d.stationProfileId);
        await _local.removePendingDelete(d.serverId, d.stationProfileId);
      } on NetworkException {
        return; // hâlâ çevrimdışı — sonraki senkronda tekrar dene
      } on TimeoutException {
        return;
      } catch (_) {
        // Sunucu kaydı zaten silmiş olabilir — kuyruktan düş
        await _local.removePendingDelete(d.serverId, d.stationProfileId);
      }
    }
  }

  int get unsyncedCount => _local.unsyncedCount;

  static String _qsoId(QsoModel q) {
    // Saniye hassasiyeti kullan — MySQL DATETIME milisaniyeleri saklamaz.
    // Optimistik ID ile sunucudan geri çekilen ID'nin eşleşmesi için gerekli.
    final ts = q.dateTimeOn.millisecondsSinceEpoch ~/ 1000;
    final safeCall = q.callsign.replaceAll('/', '-');
    return '${safeCall}_${ts}_${q.band}_${q.mode}';
  }
}
