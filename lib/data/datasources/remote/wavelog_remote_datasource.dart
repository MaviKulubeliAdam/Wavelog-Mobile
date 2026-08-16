import 'dart:io';

import 'package:dio/dio.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/errors/app_exception.dart';
import '../../models/callsign_lookup_model.dart';
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
      final body = station.toJson();
      if (linkActiveLogbook) body['link_active_logbook'] = '1';

      final response = await _dio.post(ApiEndpoints.station, data: body);
      final data = response.data;

      if (response.statusCode == 201 || response.statusCode == 200) {
        final id = data is Map ? (data['station_id'] ?? data['id']) : null;
        if (id != null) {
          return station.copyWith(
              id: int.tryParse(id.toString()) ?? station.id);
        }
        return station;
      }
      if (data is Map && data['status'] == 'dupe') {
        throw const ServerException('Station already exists');
      }
      throw const ServerException('Could not create station');
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  // ── Station extensions — patch (remove when v2 gains these) ─────────────────

  Future<StationModel> getStationDetail(int stationId) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.mobileGetStationDetail,
        data: {'station_id': stationId},
      );
      final data = response.data;
      if (data is Map && data['station'] is Map) {
        return StationModel.fromJson(data['station'] as Map<String, dynamic>);
      }
      throw const ServerException('Invalid server response');
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> updateStation(StationModel station) async {
    try {
      final body = station.toJson();
      body['station_id'] = station.id;
      await _dio.post(ApiEndpoints.mobileUpdateStation, data: body);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> setActiveStation(int stationId) async {
    try {
      await _dio.post(
        ApiEndpoints.mobileSetActiveStation,
        data: {'station_id': stationId},
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> deleteStation(int stationId) async {
    try {
      await _dio.post(
        ApiEndpoints.mobileDeleteStation,
        data: {'station_id': stationId},
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<int> cloneStation(int stationId, String newName) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.mobileCloneStation,
        data: {'station_id': stationId, 'new_name': newName},
      );
      final data = response.data;
      if (data is Map) return _parseInt(data['station_id']) ?? 0;
      return 0;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  // ── Logbook — patch (remove when v2 logbook resource ships) ─────────────────

  Future<List<StationLogbookModel>> getLogbooks() async {
    try {
      final response = await _dio.post(ApiEndpoints.mobileGetLogbooks);
      final data = response.data;
      if (data is Map && data['logbooks'] is List) {
        return (data['logbooks'] as List)
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
        ApiEndpoints.mobileCreateLogbook,
        data: {'logbook_name': name},
      );
      final data = response.data;
      if (data is Map) return _parseInt(data['logbook_id']) ?? 0;
      return 0;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> updateLogbook(int logbookId, String name) async {
    try {
      await _dio.post(
        ApiEndpoints.mobileUpdateLogbook,
        data: {'logbook_id': logbookId, 'logbook_name': name},
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> deleteLogbook(int logbookId) async {
    try {
      await _dio.post(
        ApiEndpoints.mobileDeleteLogbook,
        data: {'logbook_id': logbookId},
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> setActiveLogbook(int logbookId) async {
    try {
      await _dio.post(
        ApiEndpoints.mobileSetActiveLogbook,
        data: {'logbook_id': logbookId},
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> linkStationToLogbook(int logbookId, int stationId) async {
    try {
      await _dio.post(
        ApiEndpoints.mobileLinkStation,
        data: {'logbook_id': logbookId, 'station_id': stationId},
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> unlinkStationFromLogbook(int logbookId, int stationId) async {
    try {
      await _dio.post(
        ApiEndpoints.mobileUnlinkStation,
        data: {'logbook_id': logbookId, 'station_id': stationId},
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  // ── DXCC — patch (remove when v2 dxcc resource ships) ───────────────────────

  Future<List<DxccEntity>> getDxccList() async {
    try {
      final response = await _dio.post(ApiEndpoints.mobileGetDxccList);
      final data = response.data;
      if (data is Map && data['status'] == 'ok') {
        final list = data['data'] as List? ?? [];
        return list
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
      final response = await _dio.post(
        ApiEndpoints.mobileGetStateList,
        data: {'dxcc': dxcc},
      );
      final data = response.data;
      if (data is Map && data['status'] == 'ok') {
        final list = data['data'] as List? ?? [];
        return list
            .map((j) => StateSubdivision.fromJson(j as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  // ── Contest — patch (remove when v2 contest resource ships) ─────────────────

  Future<List<ContestTemplate>> getContestList() async {
    try {
      final response = await _dio.post(ApiEndpoints.mobileGetContestList);
      final data = response.data;
      if (data is Map &&
          (data['status'] == 'ok' || data['status'] == 'success')) {
        final list = data['contests'];
        if (list is List) {
          return list
              .map((j) => ContestTemplate.fromJson(j as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } on DioException catch (_) {
      return [];
    }
  }

  Future<List<ContestSession>> getContestSessions() async {
    try {
      final response = await _dio.post(ApiEndpoints.mobileGetContestSessions);
      final data = response.data;
      if (data is Map &&
          (data['status'] == 'ok' || data['status'] == 'success')) {
        final list = data['sessions'];
        if (list is List) {
          return list
              .map((j) => ContestSession.fromJson(j as Map<String, dynamic>))
              .toList();
        }
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
        ApiEndpoints.mobileCreateContestSession,
        data: {
          'contest_adif_id': contestAdifId,
          'adif_name': adifName,
          'time_start': fmt(timeStart.toUtc()),
          'time_end': fmt(timeEnd.toUtc()),
          'station_id': stationId,
          'custom_name': customName,
          'exchange_fields': exchangeFields,
          'copy_exchange_to': copyExchangeTo,
        },
      );
      final data = response.data;
      if (data is Map && (data['status'] == 'ok' || data['status'] == 'success')) {
        return int.tryParse(data['session_id']?.toString() ?? '') ?? 0;
      }
      throw ServerException(
          data is Map ? (data['reason']?.toString() ?? 'Error') : 'Error');
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

      final response = await _dio.post(
        ApiEndpoints.mobileUpdateContestSession,
        data: {
          'contest_session_id': contestSessionId,
          'contest_adif_id': contestAdifId,
          'adif_name': adifName,
          'time_start': fmt(timeStart.toUtc()),
          'time_end': fmt(timeEnd.toUtc()),
          'station_id': stationId,
          'custom_name': customName,
          'exchange_fields': exchangeFields,
          'copy_exchange_to': copyExchangeTo,
        },
      );
      final data = response.data;
      if (data is Map && data['status'] == 'failed') {
        throw ServerException(
            data['reason']?.toString() ?? 'Update failed');
      }
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> deleteContestSession(int contestSessionId) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.mobileDeleteContestSession,
        data: {'contest_session_id': contestSessionId},
      );
      final data = response.data;
      if (data is Map && data['status'] == 'failed') {
        throw ServerException(data['reason']?.toString() ?? 'Delete failed');
      }
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> logContestQso({
    required int contestSessionId,
    required int stationProfileId,
    required String adifString,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.mobileLogContestQso,
        data: {
          'contest_session_id': contestSessionId,
          'station_profile_id': stationProfileId,
          'adif_string': adifString,
        },
      );
      final data = response.data;
      if (data is Map && data['status'] == 'failed') {
        throw ServerException(data['reason']?.toString() ?? 'Error');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404 ||
          e.type == DioExceptionType.connectionError) {
        await importQso(adifString, stationProfileId);
        return;
      }
      throw _mapDioException(e);
    }
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
