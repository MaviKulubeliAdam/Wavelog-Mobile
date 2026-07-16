/// Spot API'lerinden gelen, 'Z' soneki olmayabilen UTC zaman damgasını çözer.
/// (Önceden POTA/SOTA/WWFF modellerinde üçer kopyası vardı.)
DateTime parseUtcLoose(String? raw) {
  if (raw == null || raw.isEmpty) return DateTime.now().toUtc();
  final s = raw.endsWith('Z') || raw.contains('+') ? raw : '${raw}Z';
  return DateTime.tryParse(s)?.toUtc() ?? DateTime.now().toUtc();
}
