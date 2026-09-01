class ConfirmationRecord {
  final int qsoId;
  final String type; // "LoTW", "eQSL", "QRZ.com", "ClubLog", "QSL"
  final String confirmationDate;

  const ConfirmationRecord({
    required this.qsoId,
    required this.type,
    required this.confirmationDate,
  });

  factory ConfirmationRecord.fromJson(Map<String, dynamic> j) =>
      ConfirmationRecord(
        qsoId: int.tryParse(j['qso_id']?.toString() ?? '') ?? 0,
        type: _normaliseType(j['type']?.toString() ?? ''),
        confirmationDate: j['confirmation_date']?.toString() ?? '',
      );

  static String _normaliseType(String raw) {
    switch (raw.toLowerCase()) {
      case 'lotw':   return 'LoTW';
      case 'eqsl':   return 'eQSL';
      case 'qrz':
      case 'qrz.com': return 'QRZ.com';
      case 'clublog': return 'ClubLog';
      case 'qsl':    return 'QSL';
      default:       return raw;
    }
  }
}
