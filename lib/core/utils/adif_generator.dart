import 'dart:convert';

import '../../data/models/qso_model.dart';

class AdifGenerator {
  // Dahili alanlar — ADIF çıktısına dahil edilmez
  static const _skipFields = {
    'APP_WAVELOG_QSO_ID',
    'WAVELOG_QSO_ID',
    'APP_WAVELOG_FLAG',   // sadece görüntü için, ADIF standardı dışı
    'ID',
    'STATION_PROFILE_ID',
  };

  static String generate(
    List<QsoModel> qsos, {
    String programId = 'Wavelog Mobile',
    String version = '3.1.0',
  }) {
    final buf = StringBuffer();
    buf.writeln('Wavelog ADIF export');
    buf.writeln(_field('ADIF_VER', version));
    buf.writeln(_field('PROGRAMID', programId));
    buf.writeln(_field('PROGRAMVERSION', '1.0'));
    buf.writeln('<EOH>');
    buf.writeln();
    for (final qso in qsos) {
      buf.write(_qsoToAdif(qso));
      buf.writeln();
    }
    return buf.toString();
  }

  static String generateSingle(QsoModel qso) => _qsoToAdif(qso);

  static String fromParsedRecords(List<Map<String, String>> records) {
    final buf = StringBuffer();
    for (final record in records) {
      for (final entry in record.entries) {
        buf.writeln(_field(entry.key, entry.value));
      }
      buf.writeln('<EOR>');
      buf.writeln();
    }
    return buf.toString();
  }

  static String _qsoToAdif(QsoModel qso) {
    final buf = StringBuffer();
    final raw = qso.rawAdif;
    var wroteFromRaw = false;

    if (raw != null && raw.isNotEmpty) {
      // Sunucudan gelen tüm ADIF alanlarını doğrudan kullan
      for (final entry in raw.entries) {
        final key = entry.key;
        final value = entry.value;
        if (_skipFields.contains(key)) continue;
        if (value.isEmpty) continue;
        buf.writeln(_field(key, value));
        wroteFromRaw = true;
      }
    }

    if (!wroteFromRaw) {
      // Yedek: rawAdif yoksa veya sadece display alanları içeriyorsa (ör. APP_WAVELOG_FLAG)
      // QSO model alanlarından ADIF üret
      final dt = qso.dateTimeOn.toUtc();
      buf.writeln(_field('CALL', qso.callsign));
      buf.writeln(_field('QSO_DATE', _fmtDate(dt)));
      buf.writeln(_field('TIME_ON', _fmtTime(dt)));
      buf.writeln(_field('BAND', qso.band));
      if (qso.freqMhz != null) {
        buf.writeln(_field('FREQ', qso.freqMhz!.toStringAsFixed(3)));
      }
      buf.writeln(_field('MODE', qso.mode));
      if (qso.submode?.isNotEmpty == true) {
        buf.writeln(_field('SUBMODE', qso.submode!));
      }
      buf.writeln(_field('RST_SENT', qso.rstSent));
      buf.writeln(_field('RST_RCVD', qso.rstRcvd));
      if (qso.name?.isNotEmpty == true) buf.writeln(_field('NAME', qso.name!));
      if (qso.qth?.isNotEmpty == true) buf.writeln(_field('QTH', qso.qth!));
      if (qso.gridSquare?.isNotEmpty == true) {
        buf.writeln(_field('GRIDSQUARE', qso.gridSquare!));
      }
      if (qso.country?.isNotEmpty == true) {
        buf.writeln(_field('COUNTRY', qso.country!));
      }
      if (qso.continent?.isNotEmpty == true) {
        buf.writeln(_field('CONT', qso.continent!));
      }
      if (qso.dxcc?.isNotEmpty == true) buf.writeln(_field('DXCC', qso.dxcc!));
      if (qso.comment?.isNotEmpty == true) {
        buf.writeln(_field('COMMENT', qso.comment!));
      }
    }

    buf.writeln('<EOR>');
    return buf.toString();
  }

  // Her alanı ayrı satırda yaz (web formatıyla aynı).
  // ADIF alan uzunluğu BAYT cinsindendir — UTF-16 birim sayısı (String.length)
  // Türkçe/Lehçe karakterlerde yanlış sonuç verir.
  static String _field(String name, String value) =>
      '<$name:${utf8.encode(value).length}>$value';

  static String _fmtDate(DateTime dt) =>
      '${dt.year.toString().padLeft(4, '0')}'
      '${dt.month.toString().padLeft(2, '0')}'
      '${dt.day.toString().padLeft(2, '0')}';

  static String _fmtTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}'
      '${dt.minute.toString().padLeft(2, '0')}'
      '${dt.second.toString().padLeft(2, '0')}';
}
