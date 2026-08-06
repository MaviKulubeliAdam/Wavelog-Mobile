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

class WavelogRemoteDatasource {
  final Dio _dio;
  final String _apiKey;

  WavelogRemoteDatasource({required Dio dio, required String apiKey})
      : _dio = dio,
        _apiKey = apiKey;

  Future<bool> importQso(String adifData, int stationProfileId) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.qsoImport,
        data: {
          'key': _apiKey,
          'station_profile_id': stationProfileId,
          'type': 'adif',
          'string': adifData,
        },
      );
      final data = response.data;
      if (data is Map) {
        return data['status'] == 'created' ||
            data['status'] == 'ok' ||
            response.statusCode == 200 ||
            response.statusCode == 201;
      }
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<List<QsoModel>> getContacts({
    required int stationId,
    int fetchFromId = 0,
    String? band,
    int? stationProfileId,
  }) async {
    try {
      final body = <String, dynamic>{
        'key': _apiKey,
        'station_id': stationId,
        'fetchfromid': fetchFromId,
      };
      if (band != null && band.isNotEmpty) body['band'] = band;

      // Use mobile endpoint — returns same data + APP_WAVELOG_QSO_ID for delete/edit
      final response = await _dio.post(ApiEndpoints.mobileGetContacts, data: body);
      final data = response.data;

      if (data is Map && data['status'] == 'failed') {
        throw ServerException(data['reason']?.toString() ?? 'Sunucu hatası');
      }

      if (data is Map) {
        final contacts = data['qsos'] ?? [];
        if (contacts is List) {
          return contacts
              .map((j) => QsoModel.fromJson(j as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<CallsignLookupModel> lookupCallsign({
    required String callsign,
    String? band,
    String? mode,
  }) async {
    try {
      final body = <String, dynamic>{
        'key': _apiKey,
        'callsign': callsign.toUpperCase(),
        'callbook': true,
      };
      if (band != null && band.isNotEmpty) body['band'] = band;
      if (mode != null && mode.isNotEmpty) body['mode'] = mode;

      // Wavelog reads JSON body via file_get_contents("php://input") — must send JSON
      final response = await _dio.post(ApiEndpoints.privateLookup, data: body);
      final data = response.data;

      if (data is Map<String, dynamic>) {
        return CallsignLookupModel.fromJson(callsign, data);
      }

      return CallsignLookupModel(callsign: callsign.toUpperCase());
    } on DioException catch (e) {
      // Capture error body for debug panel
      final errData = e.response?.data;
      if (errData is Map<String, dynamic>) {
        return CallsignLookupModel.fromJson(callsign, errData);
      }
      throw _mapDioException(e);
    }
  }

  Future<List<StationModel>> getStations() async {
    try {
      final response =
          await _dio.get(ApiEndpoints.stationInfo(_apiKey));
      final data = response.data;

      if (data is List) {
        return data
            .map((j) => StationModel.fromJson(j as Map<String, dynamic>))
            .toList();
      }
      if (data is Map) {
        final stations = data['stations'] ?? data['data'];
        if (stations is List) {
          return stations
              .map((j) => StationModel.fromJson(j as Map<String, dynamic>))
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
      body['key'] = _apiKey;
      if (linkActiveLogbook) body['link_active_logbook'] = '1';

      final response =
          await _dio.post(ApiEndpoints.createStation, data: body);
      final data = response.data;

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (data is Map && data['station_id'] != null) {
          return station.copyWith(
              id: int.tryParse(data['station_id'].toString()) ?? station.id);
        }
        return station;
      }
      if (data is Map && data['status'] == 'dupe') {
        throw const ServerException('Bu istasyon zaten mevcut');
      }
      throw const ServerException('İstasyon oluşturulamadı');
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<StatisticsModel> getStatistics() async {
    try {
      final response = await _dio.get(ApiEndpoints.statistics(_apiKey));
      final data = response.data;
      if (data is Map) {
        return StatisticsModel.fromJson(data as Map<String, dynamic>);
      }
      return const StatisticsModel();
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> deleteQso(int serverId, int stationProfileId) async {
    try {
      await _dio.post(
        ApiEndpoints.mobileDeleteQso,
        data: {
          'key': _apiKey,
          'qso_id': serverId,
          'station_profile_id': stationProfileId,
        },
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> updateQsoFields(
      int serverId, int stationProfileId, Map<String, String> fields) async {
    try {
      await _dio.post(
        ApiEndpoints.mobileUpdateQso,
        data: {
          'key': _apiKey,
          'qso_id': serverId,
          'station_profile_id': stationProfileId,
          'fields': fields,
        },
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<String?> getVersion() async {
    try {
      final response = await _dio.post(
        ApiEndpoints.version,
        data: {'key': _apiKey},
      );
      final data = response.data;
      if (data is Map) return data['version']?.toString();
      return null;
    } on DioException catch (_) {
      return null;
    }
  }

  // ── Station location CRUD ────────────────────────────────────────

  Future<StationModel> getStationDetail(int stationId) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.mobileGetStationDetail,
        data: {'key': _apiKey, 'station_id': stationId},
      );
      final data = response.data;
      if (data is Map && data['station'] is Map) {
        return StationModel.fromJson(data['station'] as Map<String, dynamic>);
      }
      throw const ServerException('Geçersiz sunucu yanıtı');
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> updateStation(StationModel station) async {
    try {
      final body = station.toJson();
      body['key'] = _apiKey;
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
        data: {'key': _apiKey, 'station_id': stationId},
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> deleteStation(int stationId) async {
    try {
      await _dio.post(
        ApiEndpoints.mobileDeleteStation,
        data: {'key': _apiKey, 'station_id': stationId},
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<int> cloneStation(int stationId, String newName) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.mobileCloneStation,
        data: {'key': _apiKey, 'station_id': stationId, 'new_name': newName},
      );
      final data = response.data;
      if (data is Map) return _parseInt(data['station_id']) ?? 0;
      return 0;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  // ── Logbook CRUD ─────────────────────────────────────────────────

  Future<List<StationLogbookModel>> getLogbooks() async {
    try {
      final response = await _dio.post(
        ApiEndpoints.mobileGetLogbooks,
        data: {'key': _apiKey},
      );
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
        data: {'key': _apiKey, 'logbook_name': name},
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
        data: {'key': _apiKey, 'logbook_id': logbookId, 'logbook_name': name},
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> deleteLogbook(int logbookId) async {
    try {
      await _dio.post(
        ApiEndpoints.mobileDeleteLogbook,
        data: {'key': _apiKey, 'logbook_id': logbookId},
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> setActiveLogbook(int logbookId) async {
    try {
      await _dio.post(
        ApiEndpoints.mobileSetActiveLogbook,
        data: {'key': _apiKey, 'logbook_id': logbookId},
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  // ── Location–logbook linking ─────────────────────────────────────

  Future<void> linkStationToLogbook(int logbookId, int stationId) async {
    try {
      await _dio.post(
        ApiEndpoints.mobileLinkStation,
        data: {'key': _apiKey, 'logbook_id': logbookId, 'station_id': stationId},
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> unlinkStationFromLogbook(int logbookId, int stationId) async {
    try {
      await _dio.post(
        ApiEndpoints.mobileUnlinkStation,
        data: {'key': _apiKey, 'logbook_id': logbookId, 'station_id': stationId},
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<List<DxccEntity>> getDxccList() async {
    try {
      final response = await _dio.post(
        ApiEndpoints.mobileGetDxccList,
        data: {'key': _apiKey},
      );
      final data = response.data;
      if (data is Map && data['status'] == 'ok') {
        final list = data['data'] as List? ?? [];
        return list.map((j) => DxccEntity.fromJson(j as Map<String, dynamic>)).toList();
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
        data: {'key': _apiKey, 'dxcc': dxcc},
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

  // ── Contest ─────────────────────────────────────────────────────────────────

  Future<List<ContestTemplate>> getContestList() async {
    try {
      final response = await _dio.post(
        ApiEndpoints.mobileGetContestList,
        data: {'key': _apiKey},
      );
      final data = response.data;
      if (data is Map && (data['status'] == 'ok' || data['status'] == 'success')) {
        final list = data['contests'];
        if (list is List) {
          return list
              .map((j) => ContestTemplate.fromJson(j as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } on DioException {
      return []; // patch not installed — caller falls back to built-in list
    }
  }

  Future<List<ContestSession>> getContestSessions() async {
    try {
      final response = await _dio.post(
        ApiEndpoints.mobileGetContestSessions,
        data: {'key': _apiKey},
      );
      final data = response.data;
      if (data is Map && (data['status'] == 'ok' || data['status'] == 'success')) {
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
          'key': _apiKey,
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
          data is Map ? (data['reason']?.toString() ?? 'Hata') : 'Hata');
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
          'key': _apiKey,
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
        throw ServerException(data['reason']?.toString() ?? 'Güncelleme başarısız');
      }
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<void> deleteContestSession(int contestSessionId) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.mobileDeleteContestSession,
        data: {'key': _apiKey, 'contest_session_id': contestSessionId},
      );
      final data = response.data;
      if (data is Map && data['status'] == 'failed') {
        throw ServerException(data['reason']?.toString() ?? 'Silme başarısız');
      }
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  /// Logs a QSO and links it to a contest session.
  /// Falls back to plain ADIF import when the patch endpoint is unavailable.
  Future<void> logContestQso({
    required int contestSessionId,
    required int stationProfileId,
    required String adifString,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.mobileLogContestQso,
        data: {
          'key': _apiKey,
          'contest_session_id': contestSessionId,
          'station_profile_id': stationProfileId,
          'adif_string': adifString,
        },
      );
      final data = response.data;
      if (data is Map && data['status'] == 'failed') {
        throw ServerException(data['reason']?.toString() ?? 'Hata');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404 || e.type == DioExceptionType.connectionError) {
        // Patch endpoint missing — fall back to plain import
        await importQso(adifString, stationProfileId);
        return;
      }
      throw _mapDioException(e);
    }
  }

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
                'Sunucuya bağlanılamadı — URL veya port hatalı olabilir');
          }
          if (msg.contains('failed host lookup') ||
              msg.contains('no address associated') ||
              msg.contains('nodename nor servname')) {
            return const NetworkException(
                'Sunucu adresi bulunamadı — URL\'yi kontrol edin');
          }
        }
        // Gerçekten ağ yoksa genel mesaj
        return const NetworkException('Bağlantı kurulamadı — sunucuya erişilemiyor');
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) return const UnauthorizedException();
        final msg = e.response?.data is Map
            ? e.response!.data['message']?.toString() ?? 'Sunucu hatası'
            : 'Sunucu hatası ($statusCode)';
        return ServerException(msg, statusCode: statusCode);
      case DioExceptionType.unknown:
        final inner = e.error;
        if (inner is HandshakeException) {
          return const NetworkException(
              'SSL sertifika hatası — sunucunun sertifika zinciri doğrulanamadı. '
              'Sunucu yöneticisi intermediate sertifikaları kontrol etmeli.');
        }
        return NetworkException(e.message ?? 'Bilinmeyen hata');
      default:
        return NetworkException(e.message ?? 'Bilinmeyen hata');
    }
  }
}
