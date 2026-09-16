import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final serverUrl       = ref.watch(settingsProvider.select((s) => s.serverUrl));
  final apiKey          = ref.watch(settingsProvider.select((s) => s.apiKey));
  final allowInsecure   = ref.watch(settingsProvider.select((s) => s.allowInsecureSsl));
  final baseUrl = serverUrl.isNotEmpty ? serverUrl : 'https://localhost';
  return buildWavelogDio(baseUrl, bearerToken: apiKey, allowInsecureSsl: allowInsecure);
});

/// Strips legacy/API path suffixes from the server URL so that v2 endpoint
/// paths (which start with /index.php/api/v2/...) are never doubled.
/// Users often paste in a URL they copied from their browser or from an API
/// endpoint they tested, e.g. "https://example.com/index.php/api/v2" or
/// even "https://example.com/api/v2/qso" — all of these should resolve to
/// the same base "https://example.com", since ApiEndpoints always re-adds
/// the canonical /index.php/api/v2 prefix itself.
///   "https://example.com/index.php"        → "https://example.com"
///   "https://example.com/api/v2"            → "https://example.com"
///   "https://example.com/index.php/api/v2"  → "https://example.com"
///   "https://example.com/api/v2/qso?x=1"    → "https://example.com"
String normalizeServerUrl(String url) {
  var u = url.trim();
  // Drop query string / fragment first so a pasted full endpoint URL
  // (e.g. ".../api/v2/qso?station_id=1") doesn't leave stray characters.
  u = u.split('?').first.split('#').first;
  u = u.replaceAll(RegExp(r'/+$'), '');
  // Strip an /api/vN path onward (with or without a leading /index.php),
  // regardless of what follows it.
  u = u.replaceFirst(
      RegExp(r'(/index\.php)?/api/v\d+(/.*)?$', caseSensitive: false), '');
  // Legacy: bare /index.php with no /api/vN suffix
  if (u.toLowerCase().endsWith('/index.php')) {
    u = u.substring(0, u.length - '/index.php'.length);
  }
  return u.replaceAll(RegExp(r'/+$'), '');
}

/// Wavelog sunucusuna uygun yapılandırılmış Dio örneği oluşturur.
/// [bearerToken] verilirse her isteğe Authorization: Bearer header eklenir.
/// [allowInsecureSsl] true ise TLS sertifikası doğrulanmaz (self-signed / özel CA için).
Dio buildWavelogDio(String baseUrl,
    {String bearerToken = '', bool allowInsecureSsl = false}) {
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

  if (allowInsecureSsl) {
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () => HttpClient()
        ..badCertificateCallback = (cert, host, port) => true,
    );
  }

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
