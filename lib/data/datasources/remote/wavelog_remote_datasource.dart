import 'dart:io';

import 'package:dio/dio.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/errors/app_exception.dart';
import '../../models/callsign_lookup_model.dart';
import '../../models/confirmation_model.dart';
import '../../models/contest_model.dart';
import '../../models/dxcc_entity_model.dart';
import '../../models/qso_model.dart';
import '../../models/state_subdivision_model.dart';
import '../../models/station_logbook_model.dart';
import '../../models/station_model.dart';
import '../../models/statistics_model.dart';

/// Hybrid datasource: API v2 (Bearer token) for native endpoints,
/// api_mobile patch (also Bearer token via Authorization header) for the rest.
/// Patch endpoints are removed one by one as v2 gains native equivalents.
class WavelogRemoteDatasource {
  final Dio _dio;

  WavelogRemoteDatasource({required Dio dio}) : _dio = dio;

  // ── QSO — v2 native ─────────────────────────────────────────────────────────

  Future<bool> importQso(String adifData, int stationProfileId) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.qso,
        data: {
          'station_profile_id': stationProfileId,
          'import_type': 'adif',
          'adif': adifData,
        },
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  // Wavelog v2 uses page-based pagination (page=1,2,…) with meta.has_more.
  // fetchFromId is kept for API compatibility but is no longer used for paging.
  Future<List<QsoModel>> getContacts({
    required int stationId,
    int fetchFromId = 0,
    String? band,
    int? stationProfileId,
  }) async {
    final allQsos = <QsoModel>[];
    int page = 1;

    while (true) {
      try {
        final params = <String, dynamic>{
          'station_id': stationId,
          'page': page,
        };
        if (band != null && band.isNotEmpty) params['band'] = band;

        final response = await _dio.get(ApiEndpoints.qso, queryParameters: params);
        final data = response.data;

        if (data is Map && data['status'] == 'failed') {
          throw ServerException(data['reason']?.toString() ?? 'Server error');
        }

        List<QsoModel> batch = const [];
        bool hasMore = false;

        if (data is Map) {
          // Paginated response with meta envelope
          final contacts = data['data'] ?? data['qsos'] ?? [];
          if (contacts is List) {
            batch = contacts.whereType<Map<String, dynamic>>().map(QsoModel.fromJson).toList();
          }
          // Read has_more from meta if present
          final meta = data['meta'];
          if (meta is Map) {
            hasMore = meta['has_more'] == true;
          }
        } else if (data is List) {
          batch = data.whereType<Map<String, dynamic>>().map(QsoModel.fromJson).toList();
          // Legacy flat list — no pagination info, assume single page
        }

        allQsos.addAll(batch);

        if (!hasMore) break;
        page++;
      } on DioException catch (e) {
        throw _mapDioException(e);
      }
    }

    return allQsos;
  }

  Future<void> deleteQso(int serverId, int stationProfileId) async {
    try {
      await _dio.delete(
        ApiEndpoints.qsoById(serverId),
        queryParameters: {'station_profile_id': stationProfileId},
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> updateQsoFields(
      int serverId, int stationProfileId, Map<String, dynamic> fields) async {
    try {
      await _dio.patch(
        ApiEndpoints.qsoById(serverId),
        data: {'station_profile_id': stationProfileId, ...fields},
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  // ── Callsign Lookup — v2 native ──────────────────────────────────────────────

  Future<CallsignLookupModel> lookupCallsign({
    required String callsign,
    String? band,
    String? mode,
  }) async {
    try {
      // v2 lookup is GET with query params (POST returns 405).
      // detail=full triggers per-band worked/confirmed flags and callbook lookup.
      // callbook must be the string 'true' (server checks === 'true').
      final params = <String, dynamic>{
        'callsign': callsign.toUpperCase(),
        'detail': 'full',
        'callbook': 'true',
      };
      if (band != null && band.isNotEmpty) params['band'] = band;
      if (mode != null && mode.isNotEmpty) params['mode'] = mode;

      final response = await _dio.get(
        ApiEndpoints.lookup,
        queryParameters: params,
      );
      final raw = response.data;

      if (raw is Map<String, dynamic>) {
        // v2 wraps response in {"data": {...}, "meta": {...}}
        final data = raw['data'] is Map<String, dynamic>
            ? raw['data'] as Map<String, dynamic>
            : raw;
        return CallsignLookupModel.fromJson(callsign, data);
      }
      return CallsignLookupModel(callsign: callsign.toUpperCase());
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  // ── Statistics — v2 native ───────────────────────────────────────────────────

  Future<StatisticsModel> getStatistics() async {
    try {
      final response = await _dio.get(ApiEndpoints.statistics);
      final raw = response.data;
      if (raw is Map<String, dynamic>) {
        // v2 wraps payload in {"data": {...}, "meta": {...}}
        final inner = raw['data'] is Map<String, dynamic>
            ? raw['data'] as Map<String, dynamic>
            : raw;
        return StatisticsModel.fromJson(inner);
      }
      return const StatisticsModel();
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  // ── Version — v2 native ──────────────────────────────────────────────────────

  Future<String?> getVersion() async {
    try {
      final response = await _dio.get(ApiEndpoints.version);
      final data = response.data;
      if (data is Map) return data['version']?.toString();
      return null;
    } on DioException catch (_) {
      return null;
    }
  }

  // ── Station list/create — v2 native ─────────────────────────────────────────

  Future<List<StationModel>> getStations() async {
    try {
      final response = await _dio.get(ApiEndpoints.station);
      final data = response.data;
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(StationModel.fromJson)
            .toList();
      }
      if (data is Map) {
        final list = data['data'] ?? data['stations'];
        if (list is List) {
          return list
              .whereType<Map<String, dynamic>>()
              .map(StationModel.fromJson)
              .toList();
        }
      }
      return [];
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<StationModel> createStation(
      StationModel station, {bool linkActiveLogbook = false}) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.station,
        data: _stationV2Body(station),
      );
      final data = response.data;
      if (response.statusCode == 201 || response.statusCode == 200) {
        final inner = data is Map ? data['data'] : null;
        final id = inner is Map ? inner['id'] : null;
        if (id != null) {
          return station.copyWith(id: _parseInt(id) ?? station.id);
        }
        return station;
      }
      throw const ServerException('Could not create station');
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  // ── Station extensions — v2 ──────────────────────────────────────────────────

  Future<StationModel> getStationDetail(int stationId) async {
    try {
      final response = await _dio.get(ApiEndpoints.stationById(stationId));
      final data = response.data;
      if (data is Map && data['data'] is Map) {
        return StationModel.fromJson(data['data'] as Map<String, dynamic>);
      }
      throw const ServerException('Invalid server response');
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> updateStation(StationModel station) async {
    try {
      await _dio.patch(
        ApiEndpoints.stationById(station.id),
        data: _stationV2Body(station),
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> setActiveStation(int stationId) async {
    try {
      await _dio.patch(
        ApiEndpoints.stationById(stationId),
        data: {'set_active': true},
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> deleteStation(int stationId) async {
    try {
      await _dio.delete(ApiEndpoints.stationById(stationId));
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<int> cloneStation(int stationId, String newName) async {
    try {
      final srcResp = await _dio.get(ApiEndpoints.stationById(stationId));
      final srcData = srcResp.data;
      if (srcData is! Map || srcData['data'] is! Map) return 0;

      final src = Map<String, dynamic>.from(srcData['data'] as Map);
      src['name'] = newName;
      // active and uuid are server-generated; exclude them
      src.remove('active');
      src.remove('uuid');
      src.remove('id');
      src.remove('country');

      final resp = await _dio.post(ApiEndpoints.station, data: src);
      final d = resp.data;
      if (d is Map && d['data'] is Map) {
        return _parseInt((d['data'] as Map)['id']) ?? 0;
      }
      return 0;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  // ── Logbook — v2 ────────────────────────────────────────────────────────────

  Future<List<StationLogbookModel>> getLogbooks() async {
    try {
      final response = await _dio.get(ApiEndpoints.logbook);
      final data = response.data;
      if (data is Map && data['data'] is List) {
        return (data['data'] as List)
            .map((j) => StationLogbookModel.fromJson(j as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<int> createLogbook(String name) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.logbook,
        data: {'name': name},
      );
      final data = response.data;
      if (data is Map && data['data'] is Map) {
        return _parseInt((data['data'] as Map)['id']) ?? 0;
      }
      return 0;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> updateLogbook(int logbookId, String name) async {
    try {
      await _dio.patch(
        ApiEndpoints.logbookById(logbookId),
        data: {'name': name},
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> deleteLogbook(int logbookId) async {
    try {
      await _dio.delete(ApiEndpoints.logbookById(logbookId));
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> setActiveLogbook(int logbookId) async {
    try {
      await _dio.patch(
        ApiEndpoints.logbookById(logbookId),
        data: {'set_active': true},
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> linkStationToLogbook(int logbookId, int stationId) async {
    try {
      final current = await _getLogbookStationIds(logbookId);
      if (!current.contains(stationId)) {
        await _dio.patch(
          ApiEndpoints.logbookById(logbookId),
          data: {'station_ids': [...current, stationId]},
        );
      }
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> unlinkStationFromLogbook(int logbookId, int stationId) async {
    try {
      final current = await _getLogbookStationIds(logbookId);
      final updated = current.where((id) => id != stationId).toList();
      await _dio.patch(
        ApiEndpoints.logbookById(logbookId),
        data: {'station_ids': updated},
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<List<int>> _getLogbookStationIds(int logbookId) async {
    final resp = await _dio.get(ApiEndpoints.logbookById(logbookId));
    final d = resp.data;
    if (d is Map && d['data'] is Map) {
      final ids = (d['data'] as Map)['station_ids'];
      if (ids is List) return ids.map((e) => _parseInt(e) ?? 0).where((e) => e > 0).toList();
    }
    return [];
  }

  // ── DXCC / Catalog — v2 ─────────────────────────────────────────────────────

  Future<List<DxccEntity>> getDxccList() async {
    try {
      final response = await _dio.get(
        ApiEndpoints.catalog,
        queryParameters: {'topic': 'dxcc'},
      );
      final data = response.data;
      if (data is Map && data['data'] is List) {
        return (data['data'] as List)
            .map((j) => DxccEntity.fromJson(j as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<List<StateSubdivision>> getStateList(int dxcc) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.catalog,
        queryParameters: {'topic': 'subdivisions', 'dxcc': dxcc},
      );
      final data = response.data;
      if (data is Map && data['data'] is List) {
        return (data['data'] as List)
            .map((j) => StateSubdivision.fromJson(j as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  // ── Contest — v2 ────────────────────────────────────────────────────────────

  Future<List<ContestTemplate>> getContestList() async {
    try {
      final response = await _dio.get(
        ApiEndpoints.catalog,
        queryParameters: {'topic': 'contest'},
      );
      final data = response.data;
      if (data is Map && data['data'] is List) {
        return (data['data'] as List)
            .map((j) => ContestTemplate.fromJson(j as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (_) {
      return [];
    }
  }

  Future<List<ContestSession>> getContestSessions() async {
    try {
      final response = await _dio.get(ApiEndpoints.contest);
      final data = response.data;
      if (data is Map && data['data'] is List) {
        return (data['data'] as List)
            .map((j) => ContestSession.fromJson(j as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<int> createContestSession({
    required int contestAdifId,
    required DateTime timeStart,
    required DateTime timeEnd,
    required int stationId,
    String adifName = '',
    String customName = '',
    List<String> exchangeFields = const ['serial'],
    String copyExchangeTo = '',
  }) async {
    try {
      String fmt(DateTime dt) =>
          '${dt.year.toString().padLeft(4, '0')}-'
          '${dt.month.toString().padLeft(2, '0')}-'
          '${dt.day.toString().padLeft(2, '0')} '
          '${dt.hour.toString().padLeft(2, '0')}:'
          '${dt.minute.toString().padLeft(2, '0')}:00';

      final response = await _dio.post(
        ApiEndpoints.contest,
        data: {
          'contest': adifName,
          'time_start': fmt(timeStart.toUtc()),
          'time_end': fmt(timeEnd.toUtc()),
          'station_id': stationId,
          'settings': {
            'exchangefields': exchangeFields,
            'copyexchangeto': copyExchangeTo,
          },
        },
      );
      final data = response.data;
      if (data is Map && data['data'] is Map) {
        return _parseInt((data['data'] as Map)['id']) ?? 0;
      }
      throw const ServerException('Could not create contest session');
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> updateContestSession({
    required int contestSessionId,
    required int contestAdifId,
    required DateTime timeStart,
    required DateTime timeEnd,
    required int stationId,
    String adifName = '',
    String customName = '',
    List<String> exchangeFields = const ['serial'],
    String copyExchangeTo = '',
  }) async {
    try {
      String fmt(DateTime dt) =>
          '${dt.year.toString().padLeft(4, '0')}-'
          '${dt.month.toString().padLeft(2, '0')}-'
          '${dt.day.toString().padLeft(2, '0')} '
          '${dt.hour.toString().padLeft(2, '0')}:'
          '${dt.minute.toString().padLeft(2, '0')}:00';

      await _dio.patch(
        ApiEndpoints.contestById(contestSessionId),
        data: {
          'contest': adifName,
          'time_start': fmt(timeStart.toUtc()),
          'time_end': fmt(timeEnd.toUtc()),
          'station_id': stationId,
          'settings': {
            'exchangefields': exchangeFields,
            'copyexchangeto': copyExchangeTo,
          },
        },
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> deleteContestSession(int contestSessionId) async {
    try {
      await _dio.delete(ApiEndpoints.contestById(contestSessionId));
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> logContestQso({
    required int contestSessionId,
    required int stationProfileId,
    required String adifString,
  }) async {
    int? qsoId;
    try {
      final response = await _dio.post(
        ApiEndpoints.qso,
        data: {
          'station_profile_id': stationProfileId,
          'import_type': 'adif',
          'adif': adifString,
        },
      );
      final raw = response.data;
      if (raw is Map) {
        final d = raw['data'];
        qsoId = _parseInt(d is Map ? d['id'] : null);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        await importQso(adifString, stationProfileId);
        return;
      }
      throw _mapDioException(e);
    }

    if (qsoId != null && qsoId > 0) {
      try {
        await _dio.patch(
          ApiEndpoints.contestById(contestSessionId),
          data: {'link_qso_ids': [qsoId]},
        );
      } on DioException catch (_) {
        // QSO logged but not linked to session — non-critical
      }
    }
  }

  // ── Confirmations — v2 ──────────────────────────────────────────────────────

  /// Fetches all confirmation pages and returns a map of qsoId → list of types.
  Future<Map<int, List<String>>> getConfirmations() async {
    final all = <ConfirmationRecord>[];
    int page = 1;
    while (true) {
      try {
        final response = await _dio.get(
          ApiEndpoints.confirmation,
          queryParameters: {'page': page},
        );
        final data = response.data;
        if (data is! Map) break;
        final list = data['data'];
        if (list is List) {
          all.addAll(list
              .whereType<Map<String, dynamic>>()
              .map(ConfirmationRecord.fromJson));
        }
        final meta = data['meta'];
        if (meta is! Map || meta['has_more'] != true) break;
        page++;
      } on DioException catch (_) {
        break;
      }
    }
    final map = <int, List<String>>{};
    for (final r in all) {
      if (r.qsoId > 0) {
        map.putIfAbsent(r.qsoId, () => []);
        if (!map[r.qsoId]!.contains(r.type)) map[r.qsoId]!.add(r.type);
      }
    }
    return map;
  }

  // ── Station v2 body builder ──────────────────────────────────────────────────

  static Map<String, dynamic> _stationV2Body(StationModel s) {
    final body = <String, dynamic>{
      'name': s.profileName,
      'callsign': s.callsign,
      'gridsquare': s.gridSquare ?? '',
      'city': s.city ?? '',
    };
    if (s.dxcc != null) body['dxcc'] = s.dxcc;
    if (s.cqZone != null) body['cq'] = s.cqZone;
    if (s.ituZone != null) body['itu'] = s.ituZone;
    if (s.state != null && s.state!.isNotEmpty) body['state'] = s.state;
    if (s.county != null && s.county!.isNotEmpty) body['cnty'] = s.county;
    if (s.iota != null && s.iota!.isNotEmpty) body['iota'] = s.iota;
    if (s.sota != null && s.sota!.isNotEmpty) body['sota'] = s.sota;
    if (s.wwff != null && s.wwff!.isNotEmpty) body['wwff'] = s.wwff;
    if (s.pota != null && s.pota!.isNotEmpty) body['pota'] = s.pota;
    if (s.sig != null && s.sig!.isNotEmpty) body['sig'] = s.sig;
    if (s.sigInfo != null && s.sigInfo!.isNotEmpty) body['sig_info'] = s.sigInfo;
    if (s.power != null) body['power'] = s.power;
    return body;
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  AppException _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
        final inner = e.error;
        if (inner is SocketException) {
          final msg = inner.message.toLowerCase();
          if (msg.contains('connection refused')) {
            return const NetworkException(
                'Cannot connect to server — check the URL or port');
          }
          if (msg.contains('failed host lookup') ||
              msg.contains('no address associated') ||
              msg.contains('nodename nor servname')) {
            return const NetworkException(
                'Server address not found — check the URL');
          }
        }
        return const NetworkException(
            'Connection failed — server unreachable');
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401 || statusCode == 403) return const UnauthorizedException();
        final body = e.response?.data;
        final String msg;
        if (body is Map) {
          // v2 API: {"error": {"code": "...", "message": "..."}}
          final errObj = body['error'];
          msg = (errObj is Map
                  ? errObj['message']?.toString()
                  : body['message']?.toString()) ??
              'Server error ($statusCode)';
        } else {
          msg = 'Server error ($statusCode)';
        }
        return ServerException(msg, statusCode: statusCode);
      case DioExceptionType.unknown:
        final inner = e.error;
        if (inner is HandshakeException) {
          return const NetworkException(
              'SSL certificate error — the server certificate chain could not be verified.');
        }
        return NetworkException(e.message ?? 'Unknown error');
      default:
        return NetworkException(e.message ?? 'Unknown error');
    }
  }
}
