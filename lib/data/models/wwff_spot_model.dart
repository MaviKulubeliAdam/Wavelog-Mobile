import '../../core/constants/band_mode_data.dart';
import '../../core/utils/spot_utils.dart';

class WwffSpotModel {
  final int id;
  final DateTime spotTime;
  final String activator;
  final String spotter;
  final int freqKhz;
  final String mode;
  final String reference;     // "KFF-5096"
  final String referenceName;
  final String comments;

  const WwffSpotModel({
    required this.id,
    required this.spotTime,
    required this.activator,
    required this.spotter,
    required this.freqKhz,
    required this.mode,
    required this.reference,
    required this.referenceName,
    required this.comments,
  });

  // Prefix before hyphen: "KFF" from "KFF-5096"
  String get countryPrefix =>
      reference.contains('-') ? reference.split('-').first : reference;

  String? get band => bandFromKhz(freqKhz.toDouble());

  String get freqDisplay {
    if (freqKhz >= 1000) {
      return '${(freqKhz / 1000).toStringAsFixed(3)} MHz';
    }
    return '$freqKhz kHz';
  }

  factory WwffSpotModel.fromJson(Map<String, dynamic> json) {
    // spot_time is Unix timestamp (seconds)
    final tsRaw = json['spot_time'];
    final DateTime spotTime;
    if (tsRaw is int) {
      spotTime = DateTime.fromMillisecondsSinceEpoch(tsRaw * 1000, isUtc: true);
    } else {
      spotTime = parseUtcLoose(json['spot_time_formatted']?.toString());
    }

    return WwffSpotModel(
      id: json['id'] as int? ?? 0,
      spotTime: spotTime,
      activator: json['activator']?.toString() ?? '',
      spotter: json['spotter']?.toString() ?? '',
      freqKhz: (json['frequency_khz'] as num?)?.toInt() ?? 0,
      mode: json['mode']?.toString() ?? '',
      reference: json['reference']?.toString() ?? '',
      referenceName: json['reference_name']?.toString() ?? '',
      comments: json['remarks']?.toString() ?? '',
    );
  }
}

class WwffSpotFilter {
  final String? band;
  final String? mode;
  final String? country;
  final bool newestFirst;

  const WwffSpotFilter({
    this.band,
    this.mode,
    this.country,
    this.newestFirst = true,
  });

  WwffSpotFilter copyWith({
    Object? band = _s,
    Object? mode = _s,
    Object? country = _s,
    bool? newestFirst,
  }) =>
      WwffSpotFilter(
        band: band == _s ? this.band : band as String?,
        mode: mode == _s ? this.mode : mode as String?,
        country: country == _s ? this.country : country as String?,
        newestFirst: newestFirst ?? this.newestFirst,
      );

  bool get hasFilters => band != null || mode != null || country != null;
  static const _s = Object();
}
