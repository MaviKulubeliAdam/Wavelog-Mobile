import '../../data/models/qso_model.dart';
import '../errors/app_exception.dart';

class AdifParser {
  static final _fieldRegex = RegExp(
    r'<(\w+)(?::\d+(?::[A-Z])?)?>([^<]*)',
    caseSensitive: false,
  );

  static List<Map<String, String>> parse(String adifContent) {
    String content = adifContent;

    // Strip header (everything before <EOH>)
    final eohIndex = content.toLowerCase().indexOf('<eoh>');
    if (eohIndex != -1) {
      content = content.substring(eohIndex + 5);
    }

    // Split on <EOR>
    final records = content
        .split(RegExp(r'<eor>', caseSensitive: false))
        .map((r) => r.trim())
        .where((r) => r.isNotEmpty)
        .toList();

    final result = <Map<String, String>>[];
    for (final record in records) {
      final fields = <String, String>{};
      for (final match in _fieldRegex.allMatches(record)) {
        final fieldName = match.group(1)!.toUpperCase().trim();
        final fieldValue = match.group(2)?.trim() ?? '';
        if (fieldName.isNotEmpty && fieldValue.isNotEmpty) {
          fields[fieldName] = fieldValue;
        }
      }
      if (fields.isNotEmpty) result.add(fields);
    }
    return result;
  }

  static QsoModel mapToQso(Map<String, String> fields, int stationProfileId) {
    final qsoDate = fields['QSO_DATE'] ?? '';
    final timeOn = fields['TIME_ON'] ?? '0000';

    DateTime dateTimeOn;
    try {
      final y = int.parse(qsoDate.substring(0, 4));
      final mo = int.parse(qsoDate.substring(4, 6));
      final d = int.parse(qsoDate.substring(6, 8));
      final h = timeOn.length >= 4 ? int.parse(timeOn.substring(0, 2)) : 0;
      final m = timeOn.length >= 4 ? int.parse(timeOn.substring(2, 4)) : 0;
      final s = timeOn.length >= 6 ? int.parse(timeOn.substring(4, 6)) : 0;
      dateTimeOn = DateTime.utc(y, mo, d, h, m, s);
    } catch (_) {
      dateTimeOn = DateTime.now().toUtc();
    }

    double? freqMhz;
    final freqStr = fields['FREQ'];
    if (freqStr != null) {
      freqMhz = double.tryParse(freqStr.replaceAll(',', '.'));
    }

    return QsoModel(
      callsign: fields['CALL'] ?? '',
      dateTimeOn: dateTimeOn,
      band: fields['BAND'] ?? '',
      freqMhz: freqMhz,
      mode: fields['MODE'] ?? '',
      submode: fields['SUBMODE'],
      rstSent: fields['RST_SENT'] ?? '59',
      rstRcvd: fields['RST_RCVD'] ?? '59',
      name: fields['NAME'],
      qth: fields['QTH'],
      gridSquare: fields['GRIDSQUARE'],
      comment: fields['COMMENT'],
      notes: fields['NOTES'],
      dxcc: fields['DXCC'],
      country: fields['COUNTRY'],
      continent: fields['CONT'],
      stationProfileId: stationProfileId,
      synced: false,
      rawAdif: Map<String, String>.from(fields),
    );
  }

  static int countRecords(String adifContent) {
    return parse(adifContent).length;
  }

  static void validate(String adifContent) {
    if (adifContent.trim().isEmpty) {
      throw const AdifParseException('ADIF dosyası boş');
    }
    final records = parse(adifContent);
    if (records.isEmpty) {
      throw const AdifParseException('ADIF dosyasında geçerli kayıt bulunamadı');
    }
  }
}
