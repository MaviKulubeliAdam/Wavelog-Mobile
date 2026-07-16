import '../../core/constants/band_mode_data.dart';
import '../../core/utils/spot_utils.dart';

class PotaSpotModel {
  final int spotId;
  final DateTime spotTime;
  final String activator;
  final String frequency; // kHz as string
  final String mode;
  final String reference;
  final String spotter;
  final String source;
  final String comments;
  final String parkName;
  final String locationDesc;

  const PotaSpotModel({
    required this.spotId,
    required this.spotTime,
    required this.activator,
    required this.frequency,
    required this.mode,
    required this.reference,
    required this.spotter,
    required this.source,
    required this.comments,
    required this.parkName,
    required this.locationDesc,
  });

  String get countryPrefix =>
      reference.contains('-') ? reference.split('-')[0] : reference;

  String? get band => bandFromKhz(double.tryParse(frequency) ?? 0);

  String get freqDisplay {
    final khz = double.tryParse(frequency) ?? 0;
    if (khz >= 1000) {
      return '${(khz / 1000).toStringAsFixed(3)} MHz';
    }
    return '$frequency kHz';
  }

  factory PotaSpotModel.fromJson(Map<String, dynamic> json) {
    return PotaSpotModel(
      spotId: json['spotId'] as int? ?? 0,
      spotTime: parseUtcLoose(json['spotTime']?.toString()),
      activator: json['activator']?.toString() ?? '',
      frequency: json['frequency']?.toString() ?? '',
      mode: json['mode']?.toString() ?? '',
      reference: json['reference']?.toString() ?? '',
      spotter: json['spotter']?.toString() ?? '',
      source: json['source']?.toString() ?? '',
      comments: json['comments']?.toString() ?? '',
      parkName: json['name']?.toString() ?? '',
      locationDesc: json['locationDesc']?.toString() ?? '',
    );
  }
}

class PotaSpotFilter {
  final String? band;
  final String? mode;
  final String? country;
  final bool newestFirst;

  const PotaSpotFilter({
    this.band,
    this.mode,
    this.country,
    this.newestFirst = true,
  });

  PotaSpotFilter copyWith({
    Object? band = _sentinel,
    Object? mode = _sentinel,
    Object? country = _sentinel,
    bool? newestFirst,
  }) {
    return PotaSpotFilter(
      band: band == _sentinel ? this.band : band as String?,
      mode: mode == _sentinel ? this.mode : mode as String?,
      country: country == _sentinel ? this.country : country as String?,
      newestFirst: newestFirst ?? this.newestFirst,
    );
  }

  bool get hasFilters => band != null || mode != null || country != null;

  static const _sentinel = Object();
}
