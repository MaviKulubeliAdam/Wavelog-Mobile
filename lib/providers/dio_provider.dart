import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final serverUrl = ref.watch(settingsProvider.select((s) => s.serverUrl));
  final apiKey    = ref.watch(settingsProvider.select((s) => s.apiKey));
  final baseUrl = serverUrl.isNotEmpty ? serverUrl : 'https://localhost';
  return buildWavelogDio(baseUrl, bearerToken: apiKey);
});

/// Strips legacy path suffixes from the server URL so that v2 endpoint paths
/// (which start with /index.php/...) are never doubled.
/// e.g. "https://example.com/index.php" → "https://example.com"
String normalizeServerUrl(String url) {
  var u = url.trimRight().replaceAll(RegExp(r'/+$'), '');
  // Strip /index.php suffix left over from v1 configuration
  if (u.endsWith('/index.php')) {
    u = u.substring(0, u.length - '/index.php'.length);
  }
  return u;
}

/// Wavelog sunucusuna uygun yapılandırılmış Dio örneği oluşturur.
/// [bearerToken] verilirse her isteğe Authorization: Bearer header eklenir.
Dio buildWavelogDio(String baseUrl, {String bearerToken = ''}) {
  final headers = <String, String>{'Accept': 'application/json'};
  baseUrl = normalizeServerUrl(baseUrl);
  if (bearerToken.isNotEmpty) {
    headers['Authorization'] = 'Bearer $bearerToken';
  }

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
      headers: headers,
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
      requestHeader: false,
      responseBody: false,
      logPrint: (obj) => debugPrint(obj.toString()),
    ));
  }

  return dio;
}
