import 'package:flutter/services.dart';

enum LocationPermission { denied, deniedForever, whileInUse, always, unableToDetermine }

class Position {
  final double latitude;
  final double longitude;
  const Position({required this.latitude, required this.longitude});
}

class NativeLocationException implements Exception {
  final String message;
  NativeLocationException(this.message);
  @override
  String toString() => message;
}

/// GMS-free replacement for `package:geolocator` used on the F-Droid build,
/// backed by Android's native LocationManager via a platform channel.
class NativeLocation {
  static const _channel = MethodChannel('com.wavelog_mobile/location');

  static Future<LocationPermission> checkPermission() async {
    final result = await _channel.invokeMethod<String>('checkPermission');
    return _parsePermission(result);
  }

  static Future<LocationPermission> requestPermission() async {
    final result = await _channel.invokeMethod<String>('requestPermission');
    return _parsePermission(result);
  }

  static Future<Position> getCurrentPosition() async {
    final result = await _channel.invokeMethod<Map>('getCurrentPosition');
    if (result == null) throw NativeLocationException('No location result');
    return Position(
      latitude: result['latitude'] as double,
      longitude: result['longitude'] as double,
    );
  }

  static LocationPermission _parsePermission(String? value) {
    switch (value) {
      case 'whileInUse':
        return LocationPermission.whileInUse;
      case 'always':
        return LocationPermission.always;
      case 'deniedForever':
        return LocationPermission.deniedForever;
      default:
        return LocationPermission.denied;
    }
  }
}
