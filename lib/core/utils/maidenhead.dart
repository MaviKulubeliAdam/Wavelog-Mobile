/// Converts WGS-84 coordinates to a 6-character Maidenhead grid locator.
/// Returns null when coordinates are out of range.
String? latLngToGrid(double lat, double lon) {
  if (lat < -90 || lat > 90 || lon < -180 || lon > 180) return null;

  // Normalize to 0-based ranges
  final nLon = lon + 180.0;
  final nLat = lat + 90.0;

  // Field (A-R)
  final fieldLon = String.fromCharCode(65 + (nLon / 20).floor());
  final fieldLat = String.fromCharCode(65 + (nLat / 10).floor());

  // Square (0-9)
  final squareLon = ((nLon % 20) / 2).floor().toString();
  final squareLat = (nLat % 10).floor().toString();

  // Subsquare (a-x)
  final subLon = String.fromCharCode(97 + ((nLon % 2) / (2 / 24)).floor());
  final subLat = String.fromCharCode(97 + ((nLat % 1) / (1 / 24)).floor());

  return '$fieldLon$fieldLat$squareLon$squareLat$subLon$subLat';
}
