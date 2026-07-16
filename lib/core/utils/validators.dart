// Desteklenen formatlar:
//   Standart       : SP9AQG, W1AW, K1A
//   Prefix/çağrı   : SV5/SP9AQG, W1/SP9AQG
//   Suffix (/P /M) : SP9AQG/P, SP9AQG/M, SP9AQG/MM, SP9AQG/QRP, W1AW/1
final _callsignRegex = RegExp(
  r'^([A-Z0-9]{1,4}/)?[A-Z0-9]{1,3}[0-9][A-Z0-9]{0,3}[A-Z](/[A-Z0-9]{1,4})?$',
  caseSensitive: false,
);

final _gridRegex = RegExp(
  r'^[A-R]{2}[0-9]{2}([A-X]{2})?$',
  caseSensitive: false,
);

final _urlRegex = RegExp(
  r'^https?://[^\s/$.?#].[^\s]*$',
  caseSensitive: false,
);

String? validateCallsign(String? value) {
  if (value == null || value.trim().isEmpty) return 'Çağrı işareti gerekli';
  if (!_callsignRegex.hasMatch(value.trim())) return 'Geçersiz çağrı işareti formatı';
  return null;
}

String? validateGridSquare(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  if (!_gridRegex.hasMatch(value.trim())) return 'Geçersiz grid kare formatı (örn: KN41)';
  return null;
}

String? validateServerUrl(String? value) {
  if (value == null || value.trim().isEmpty) return 'Sunucu URL gerekli';
  if (!_urlRegex.hasMatch(value.trim())) return 'Geçerli bir URL girin (https://...)';
  return null;
}

String? validateApiKey(String? value) {
  if (value == null || value.trim().isEmpty) return 'API anahtarı gerekli';
  if (value.trim().length < 10) return 'API anahtarı çok kısa';
  return null;
}

String? validateRst(String? value, String mode) {
  if (value == null || value.trim().isEmpty) return 'RST gerekli';
  final digitalModes = ['FT8', 'FT4', 'JS8', 'WSPR', 'JT65', 'JT9'];
  if (digitalModes.contains(mode.toUpperCase())) {
    final parsed = double.tryParse(value.trim());
    if (parsed == null || parsed < -40 || parsed > 40) {
      return 'dB değeri giriniz (-40 ile +40 arası)';
    }
  } else {
    final digits = value.trim().replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty || digits.length > 3) return 'Geçersiz RST';
  }
  return null;
}

String? validateFrequency(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  final parsed = double.tryParse(value.trim().replaceAll(',', '.'));
  if (parsed == null || parsed <= 0) return 'Geçerli bir frekans giriniz';
  return null;
}

String? validateRequired(String? value, String fieldName) {
  if (value == null || value.trim().isEmpty) return '$fieldName gerekli';
  return null;
}
