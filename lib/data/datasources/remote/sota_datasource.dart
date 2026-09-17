import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../models/sota_spot_model.dart';

class SotaDatasource {
  // api2.sota.org.uk is deprecated (returns fake "DEPRECATED" placeholder
  // records with HTTP 200 instead of real data — silently broken, no error
  // to catch). api-db2.sota.org.uk is the current host as of 2026-09.
  static const _baseUrl = 'https://api-db2.sota.org.uk';
  // Minimum 60 seconds between requests as per SOTA API rules
  static const _minInterval = Duration(seconds: 60);
  // The new spots endpoint is a lookback window in minutes, not a count —
  // 4 hours gives a reasonable "recent activity" list.
  static const _spotsWindowMinutes = 240;

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
    // summitCode here is the full reference (e.g. "G/LD-007"); the new API
    // wants association and summit as separate fields on POST even though
    // GET returns them pre-combined.
    final ref = summitCode.toUpperCase().trim();
    final slash = ref.indexOf('/');
    final association = slash > 0 ? ref.substring(0, slash) : '';
    final summit = slash > 0 ? ref.substring(slash + 1) : ref;

    await _dio.post<dynamic>(
      '/api/spots',
      data: {
        'posterCallsign': spotter.toUpperCase().trim(),
        'activatorCallsign': activatorCallsign.toUpperCase().trim(),
        'associationCode': association,
        'summitCode': summit,
        'frequency': frequency.trim(),
        'mode': mode.trim(),
        'comments': comments.trim(),
      },
    );
  }

  Future<List<SotaSpotModel>> getSpots({int windowMinutes = _spotsWindowMinutes}) async {
    final now = DateTime.now();
    if (_cache != null &&
        _lastFetch != null &&
        now.difference(_lastFetch!) < _minInterval) {
      return _cache!;
    }

    try {
      // /all/all = no callsign/summit filter — every spot in the window.
      final response =
          await _dio.get<List<dynamic>>('/api/spots/$windowMinutes/all/all');
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
