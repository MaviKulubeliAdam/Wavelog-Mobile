import 'dart:math';

/// Converts a 4- or 6-character Maidenhead grid locator to lat/lon centre.
({double lat, double lon})? maidenheadToLatLon(String grid) {
  if (grid.length < 4) return null;
  try {
    final g = grid.toUpperCase();
    final lon = (g.codeUnitAt(0) - 65) * 20.0 - 180 + (g.codeUnitAt(2) - 48) * 2.0;
    final lat = (g.codeUnitAt(1) - 65) * 10.0 - 90 + (g.codeUnitAt(3) - 48) * 1.0;
    double lonOff = 1.0, latOff = 0.5;
    if (g.length >= 6) {
      lonOff = (g.codeUnitAt(4) - 65) * (2.0 / 24) + (1.0 / 24);
      latOff = (g.codeUnitAt(5) - 65) * (1.0 / 24) + (0.5 / 24);
    }
    return (lat: lat + latOff, lon: lon + lonOff);
  } catch (_) {
    return null;
  }
}

/// Short-path azimuth in degrees (0 = N, clockwise).
double calculateAzimuth(double lat1, double lon1, double lat2, double lon2) {
  final phi1 = lat1 * pi / 180;
  final phi2 = lat2 * pi / 180;
  final dl = (lon2 - lon1) * pi / 180;
  final y = sin(dl) * cos(phi2);
  final x = cos(phi1) * sin(phi2) - sin(phi1) * cos(phi2) * cos(dl);
  return (atan2(y, x) * 180 / pi + 360) % 360;
}

/// Great-circle distance in km.
double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const r = 6371.0;
  final phi1 = lat1 * pi / 180;
  final phi2 = lat2 * pi / 180;
  final dphi = (lat2 - lat1) * pi / 180;
  final dl = (lon2 - lon1) * pi / 180;
  final a = sin(dphi / 2) * sin(dphi / 2) +
      cos(phi1) * cos(phi2) * sin(dl / 2) * sin(dl / 2);
  return r * 2 * atan2(sqrt(a), sqrt(1 - a));
}

/// Human-readable distance string.
String formatDistance(double km) {
  if (km < 1000) return '${km.toInt()} km';
  return '${(km / 1000).toStringAsFixed(1)} Mm';
}
