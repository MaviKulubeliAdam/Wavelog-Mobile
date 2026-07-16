import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  // Yalnızca serverUrl'i izle — tüm settings'i izlemek, tema gibi alakasız
  // her ayar değişiminde Dio'yu (ve ona bağlı tüm provider'ları) yeniden
  // kurup gereksiz ağ istekleri tetikliyordu.
  final serverUrl =
      ref.watch(settingsProvider.select((s) => s.serverUrl));

  final baseUrl = serverUrl.isNotEmpty ? serverUrl : 'https://localhost';
  return buildWavelogDio(baseUrl);
});

/// Wavelog sunucusuna uygun yapılandırılmış Dio örneği oluşturur.
/// Login ekranı gibi geçici bağlantılar da bunu kullanır.
Dio buildWavelogDio(String baseUrl) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
      headers: {'Accept': 'application/json'},
    ),
  );

  // Wavelog sometimes returns JSON with non-standard Content-Type headers,
  // so Dio leaves the response as a raw String. This interceptor decodes it.
  dio.interceptors.add(InterceptorsWrapper(
    onResponse: (response, handler) {
      if (response.data is String) {
        final raw = response.data as String;
        try {
          response.data = jsonDecode(raw);
        } catch (_) {
          // Not JSON — leave as-is (normal for non-JSON endpoints)
        }
      }
      handler.next(response);
    },
    onError: (error, handler) {
      if (error.response?.data is String) {
        final raw = error.response!.data as String;
        try {
          error.response!.data = jsonDecode(raw);
        } catch (_) {
          // Error body is not JSON — leave as raw string
        }
      }
      handler.next(error);
    },
  ));

  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(
      requestBody: false,
      responseBody: false,
      logPrint: (obj) => debugPrint(obj.toString()),
    ));
  }

  return dio;
}
