import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../models/dx_spot_model.dart';

class DxClusterDatasource {
  static const _minInterval = Duration(seconds: 60);

  // Primary: DXClusterAPI v2 (jo30.de)
  final Dio _primaryDio = Dio(BaseOptions(
    baseUrl: 'https://jo30.de/dxcluster-per-rest-json',
    connectTimeout: const Duration(seconds: 12),
    receiveTimeout: const Duration(seconds: 12),
    headers: {'User-Agent': 'WavelogMobile/1.0'},
  ));

  // Fallback: DXWatch public API
  final Dio _fallbackDio = Dio(BaseOptions(
    baseUrl: 'https://www.dxwatch.com',
    connectTimeout: const Duration(seconds: 12),
    receiveTimeout: const Duration(seconds: 12),
    headers: {'User-Agent': 'WavelogMobile/1.0'},
  ));

  List<DxSpotModel>? _cache;
  DateTime? _lastFetch;

  Future<List<DxSpotModel>> getSpots({int limit = 200}) async {
    final now = DateTime.now();
    if (_cache != null &&
        _lastFetch != null &&
        now.difference(_lastFetch!) < _minInterval) {
      return _cache!;
    }

    List<DxSpotModel>? result;

    // Try primary first
    try {
      result = await _fetchPrimary(limit);
    } catch (e) {
      debugPrint('DX Cluster primary failed, trying fallback: $e');
    }

    // Fall back to DXWatch if primary failed or returned nothing
    if (result == null || result.isEmpty) {
      try {
        result = await _fetchFallback(limit);
      } catch (e) {
        debugPrint('DX Cluster fallback failed: $e');
        if (_cache != null) return _cache!;
        rethrow;
      }
    }

    _cache = result;
    _lastFetch = now;
    return result;
  }

  Future<List<DxSpotModel>> _fetchPrimary(int limit) async {
    final response = await _primaryDio.get<dynamic>(
      '/api/v2/spots',
      queryParameters: {'limit': limit, 'maxAge': 300},
    );

    final body = response.data;
    List<dynamic>? rawList;
    if (body is Map<String, dynamic>) {
      rawList = body['data'] as List<dynamic>? ??
          body['spots'] as List<dynamic>?;
    } else if (body is List) {
      rawList = body;
    }

    if (rawList == null) throw Exception('Unexpected primary response format');

    return rawList
        .whereType<Map<String, dynamic>>()
        .map(DxSpotModel.fromJson)
        .where((s) => s.dxCall.isNotEmpty)
        .toList();
  }

  Future<List<DxSpotModel>> _fetchFallback(int limit) async {
    final response = await _fallbackDio.get<dynamic>(
      '/dxsd1/s.php',
      queryParameters: {'f': 0, 'c': 0, 'r': 0, 's': 0, 'l': limit, 'cdx': ''},
    );

    final body = response.data;
    final spotsMap = (body is Map) ? body['s'] : null;
    if (spotsMap == null) throw Exception('Unexpected fallback response format');

    return (spotsMap as Map<String, dynamic>)
        .values
        .whereType<List<dynamic>>()
        .map(DxSpotModel.fromDxWatch)
        .where((s) => s.dxCall.isNotEmpty)
        .toList()
      ..sort((a, b) => b.time.compareTo(a.time));
  }
}
