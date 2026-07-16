import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../models/sota_spot_model.dart';

class SotaDatasource {
  static const _baseUrl = 'https://api2.sota.org.uk';
  // Minimum 60 seconds between requests as per SOTA API rules
  static const _minInterval = Duration(seconds: 60);

  final Dio _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {
      'User-Agent': 'WavelogMobile/1.0',
      'Content-Type': 'application/json',
    },
  ));

  List<SotaSpotModel>? _cache;
  DateTime? _lastFetch;

  /// Zirve bilgisi döner. `null` = zirve bulunamadı (404).
  /// Ağ/sunucu hatalarında fırlatır — çağıran "bulunamadı" ile karıştırmasın.
  Future<({String name, String regionName})?> getSummit(
      String reference) async {
    try {
      // Reference format: SP/TK-001 — slash stays in the URL path
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/summits/$reference',
      );
      final data = response.data;
      if (data == null) return null;
      return (
        name: data['name']?.toString() ?? reference,
        regionName: data['regionName']?.toString() ?? '',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      debugPrint('SOTA summit lookup failed for $reference: $e');
      rethrow;
    }
  }

  Future<void> postSpot({
    required String activatorCallsign,
    required String summitCode,
    required String frequency,
    required String mode,
    required String spotter,
    String comments = '',
  }) async {
    await _dio.post<dynamic>(
      '/api/spots',
      data: {
        'callsign': spotter.toUpperCase().trim(),
        'activatorCallsign': activatorCallsign.toUpperCase().trim(),
        'summitCode': summitCode.toUpperCase().trim(),
        'frequency': frequency.trim(),
        'mode': mode.trim(),
        'comments': comments.trim(),
      },
    );
  }

  Future<List<SotaSpotModel>> getSpots({int count = 50}) async {
    final now = DateTime.now();
    if (_cache != null &&
        _lastFetch != null &&
        now.difference(_lastFetch!) < _minInterval) {
      return _cache!;
    }

    try {
      final response =
          await _dio.get<List<dynamic>>('/api/spots/$count');
      final list = response.data ?? [];
      final result = list
          .whereType<Map<String, dynamic>>()
          .map(SotaSpotModel.fromJson)
          .toList();
      _cache = result;
      _lastFetch = now;
      return result;
    } catch (e) {
      debugPrint('SOTA spots fetch failed: $e');
      if (_cache != null) return _cache!;
      rethrow;
    }
  }
}
