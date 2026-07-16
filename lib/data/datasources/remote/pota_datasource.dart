import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../data/models/pota_spot_model.dart';

class PotaDatasource {
  static const _baseUrl = 'https://api.pota.app';

  final Dio _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 12),
    receiveTimeout: const Duration(seconds: 12),
    headers: {'User-Agent': 'WavelogMobile/1.0'},
  ));

  /// Park bilgisi döner. `null` = park bulunamadı (404).
  /// Ağ/sunucu hatalarında fırlatır — çağıran "bulunamadı" ile karıştırmasın.
  Future<({String name, String locationDesc})?> getPark(
      String reference) async {
    try {
      final response =
          await _dio.get<Map<String, dynamic>>('/park/$reference');
      final data = response.data;
      if (data == null) return null;
      return (
        name: data['name']?.toString() ?? reference,
        locationDesc: data['locationDesc']?.toString() ?? '',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      debugPrint('POTA park lookup failed for $reference: $e');
      rethrow;
    }
  }

  Future<List<PotaSpotModel>> getSpots() async {
    final response = await _dio.get<List<dynamic>>('/spot');
    final list = response.data ?? [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(PotaSpotModel.fromJson)
        .toList();
  }

  Future<void> addSpot({
    required String activator,
    required String spotter,
    required String frequency,
    required String mode,
    required String reference,
    String comments = '',
  }) async {
    await _dio.post<dynamic>(
      '/spot',
      data: {
        'activator': activator.toUpperCase().trim(),
        'spotter': spotter.toUpperCase().trim(),
        'frequency': frequency.trim(),
        'mode': mode.trim(),
        'reference': reference.toUpperCase().trim(),
        'source': 'Web',
        'comments': comments.trim(),
      },
    );
  }
}
