import '../../data/models/qso_model.dart';
import '../errors/app_exception.dart';

class AdifParser {
  static List<Map<String, String>> parse(String adifContent) {
    String content = adifContent;

    // Strip header (everything before <EOH>)
    final eohIndex = content.toLowerCase().indexOf('<eoh>');
    if (eohIndex != -1) {
      content = content.substring(eohIndex + 5);
    }

    // Split on <EOR>
    final rawRecords = content
        .split(RegExp(r'<eor>', caseSensitive: false))
        .map((r) => r.trim())
        .where((r) => r.isNotEmpty)
        .toList();

    return rawRecords
        .map(_parseRecord)
        .where((m) => m.isNotEmpty)
        .toList();
  }

  // LENGTH-aware field parser: <FIELD:N>VALUE reads exactly N chars.
  // Falls back to next-'<' boundary when no LENGTH is declared.
  static Map<String, String> _parseRecord(String record) {
    final fields = <String, String>{};
    int i = 0;
    while (i < record.length) {
      final tagStart = record.indexOf('<', i);
      if (tagStart == -1) break;
      final tagEnd = record.indexOf('>', tagStart);
      if (tagEnd == -1) break;

      final tag = record.substring(tagStart + 1, tagEnd);
      if (tag.toLowerCase() == 'eor') break;

      final parts = tag.split(':');
      final fieldName = parts[0].toUpperCase().trim();
      final length = parts.length > 1 ? int.tryParse(parts[1]) : null;

      if (length != null) {
        final valueStart = tagEnd + 1;
        final valueEnd = (valueStart + length).clamp(0, record.length);
        final value = record.substring(valueStart, valueEnd).trim();
        if (fieldName.isNotEmpty && value.isNotEmpty) {
          fields[fieldName] = value;
        }
        i = valueEnd;
      } else {
        // No length declared — read until next '<' (legacy / header fields)
        final nextTag = record.indexOf('<', tagEnd + 1);
        final rawValue = nextTag != -1
            ? record.substring(tagEnd + 1, nextTag)
            : record.substring(tagEnd + 1);
        final value = rawValue.trim();
        if (fieldName.isNotEmpty && value.isNotEmpty) {
          fields[fieldName] = value;
        }
        i = nextTag != -1 ? nextTag : record.length;
      }
    }
    return fields;
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
