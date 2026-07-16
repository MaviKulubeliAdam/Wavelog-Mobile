import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/api_endpoints.dart';
import 'dio_provider.dart';
import 'settings_provider.dart';

// True  → Api_mobile.php patch is installed on the server
// False → endpoint returned 404 (patch missing) or settings incomplete
final patchStatusProvider = FutureProvider<bool>((ref) async {
  final settings = ref.read(settingsProvider);
  if (settings.serverUrl.isEmpty || settings.apiKey.isEmpty) return false;

  final dio = ref.read(dioProvider);
  try {
    await dio.post(
      ApiEndpoints.mobileGetContacts,
      data: {'key': settings.apiKey, 'station_id': 0},
    );
    return true;
  } on DioException catch (e) {
    // 404 = controller doesn't exist = patch not installed
    if (e.response?.statusCode == 404) return false;
    // 400 / 401 / 500 etc. = endpoint exists, just rejected the request
    return true;
  } catch (_) {
    return false;
  }
});
