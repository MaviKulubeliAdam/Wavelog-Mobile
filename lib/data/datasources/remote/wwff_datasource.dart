import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../models/wwff_spot_model.dart';

class WwffDatasource {
  static const _spotsUrl = 'https://spots.wwff.co/static/spots.json';
  // Minimum 60 seconds between requests as per WWFF API rules
  static const _minInterval = Duration(seconds: 60);

  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'User-Agent': 'WavelogMobile/1.0'},
  ));

  List<WwffSpotModel>? _cache;
  DateTime? _lastFetch;

  Future<List<WwffSpotModel>> getSpots() async {
    final now = DateTime.now();
    if (_cache != null &&
        _lastFetch != null &&
        now.difference(_lastFetch!) < _minInterval) {
      return _cache!;
    }

    try {
      final response = await _dio.get<List<dynamic>>(_spotsUrl);
      final list = response.data ?? [];
      final result = list
          .whereType<Map<String, dynamic>>()
          .map(WwffSpotModel.fromJson)
          .toList();
      _cache = result;
      _lastFetch = now;
      return result;
    } catch (e) {
      debugPrint('WWFF spots fetch failed: $e');
      if (_cache != null) return _cache!;
      rethrow;
    }
  }
}
