import '../../core/constants/band_mode_data.dart';

class DxSpotModel {
  final String dxCall;
  final String spotter;
  final String frequency; // kHz
  final String? band;
  final String mode;
  final String info;
  final DateTime time;

  const DxSpotModel({
    required this.dxCall,
    required this.spotter,
    required this.frequency,
    this.band,
    required this.mode,
    required this.info,
    required this.time,
  });

  // Parses a single spot from DXClusterAPI v2 (jo30.de)
  // Fields: spotted, spotter, frequency (kHz int), when (ISO UTC),
  //         message, band, mode (category), submode (specific, e.g. "FT8")
  factory DxSpotModel.fromJson(Map<String, dynamic> j) {
    final rawFreq = j['frequency'];
    final freq = rawFreq is num
        ? rawFreq.toStringAsFixed(rawFreq == rawFreq.toInt() ? 0 : 1)
        : rawFreq?.toString() ?? '';

    // submode is the specific mode (FT8, JS8…), mode is category (digi/phone/cw)
    final submode = j['submode']?.toString() ?? '';
    final modeCategory = j['mode']?.toString() ?? '';
    final message = j['message']?.toString() ?? j['info']?.toString() ?? '';

    // Prefer submode (specific), fallback to category, then parse from message
    final displayMode = submode.isNotEmpty
        ? submode.toUpperCase()
        : modeCategory.isNotEmpty
            ? _normalizeCategory(modeCategory)
            : _modeFromInfo(message) ?? '';

    return DxSpotModel(
      dxCall: j['spotted']?.toString() ??
          j['dx_call']?.toString() ??
          j['dx']?.toString() ??
          '',
      spotter: j['spotter']?.toString() ??
          j['de_call']?.toString() ??
          '',
      frequency: freq,
      band: j['band']?.toString() ?? _bandFromFreq(freq),
      mode: displayMode,
      info: message,
      time: DateTime.tryParse(j['when']?.toString() ?? '')?.toUtc() ??
          DateTime.tryParse(j['time']?.toString() ?? '')?.toUtc() ??
          DateTime.now().toUtc(),
    );
  }

  String get freqDisplay {
    final f = double.tryParse(frequency);
    if (f == null) return frequency;
    if (f >= 1000) return '${(f / 1000).toStringAsFixed(3)} MHz';
    return '${f.toStringAsFixed(1)} kHz';
  }

  // "digi" → "DIGI", "phone" → "SSB", "cw" → "CW"
  static String _normalizeCategory(String cat) {
    switch (cat.toLowerCase()) {
      case 'cw': return 'CW';
      case 'phone': return 'SSB';
      case 'digi':
      case 'digital': return 'DIGI';
      default: return cat.toUpperCase();
    }
  }

  static String? _bandFromFreq(String freq) {
    final f = double.tryParse(freq);
    if (f == null) return null;
    return bandFromKhz(f);
  }

  // Parses a single spot from DXWatch (www.dxwatch.com)
  // Array format: [spotter, freqKhz, dxCall, comment, "HHMMz DD Mon", ?, cqZone, ?]
  factory DxSpotModel.fromDxWatch(List<dynamic> arr) {
    final spotter = arr.isNotEmpty ? arr[0]?.toString() ?? '' : '';
    final rawFreq = arr.length > 1 ? arr[1] : null;
    final freq = rawFreq is num
        ? rawFreq.toStringAsFixed(rawFreq == rawFreq.toInt() ? 0 : 1)
        : rawFreq?.toString() ?? '';
    final dxCall = arr.length > 2 ? arr[2]?.toString() ?? '' : '';
    final info   = arr.length > 3 ? arr[3]?.toString() ?? '' : '';
    final timeStr = arr.length > 4 ? arr[4]?.toString() ?? '' : '';

    return DxSpotModel(
      dxCall:    dxCall,
      spotter:   spotter,
      frequency: freq,
      band:      _bandFromFreq(freq),
      mode:      _modeFromInfo(info) ?? '',
      info:      info,
      time:      _parseDxWatchTime(timeStr),
    );
  }

  // Parses "2109z 30 Jun" → UTC DateTime
  static DateTime _parseDxWatchTime(String s) {
    try {
      final parts = s.replaceAll('z', '').trim().split(RegExp(r'\s+'));
      if (parts.length < 3) return DateTime.now().toUtc();
      final hhmm   = parts[0];
      final hour   = int.parse(hhmm.substring(0, 2));
      final minute = int.parse(hhmm.substring(2));
      final day    = int.parse(parts[1]);
      const months = {
        'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4,
        'May': 5, 'Jun': 6, 'Jul': 7, 'Aug': 8,
        'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12,
      };
      final month = months[parts[2]] ?? 1;
      return DateTime.utc(DateTime.now().toUtc().year, month, day, hour, minute);
    } catch (_) {
      return DateTime.now().toUtc();
    }
  }

  static String? _modeFromInfo(String info) {
    const modes = ['FT8', 'FT4', 'CW', 'SSB', 'AM', 'FM', 'RTTY',
      'PSK31', 'PSK63', 'JS8', 'SSTV', 'JT65', 'JT9', 'WSPR'];
    final upper = info.toUpperCase();
    for (final m in modes) {
      if (upper.contains(m)) return m;
    }
    return null;
  }
}
