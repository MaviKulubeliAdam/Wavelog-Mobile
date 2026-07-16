import '../../core/constants/band_mode_data.dart';
import '../../core/utils/spot_utils.dart';

class SotaSpotModel {
  final int id;
  final DateTime spotTime;
  final String activator;   // activatorCallsign
  final String spotter;     // callsign (who submitted)
  final String freqMhz;     // "14.3" — MHz as string
  final String mode;
  final String reference;   // "YU/IS-013" = associationCode + "/" + summitCode
  final String summitDetails;
  final String comments;

  const SotaSpotModel({
    required this.id,
    required this.spotTime,
    required this.activator,
    required this.spotter,
    required this.freqMhz,
    required this.mode,
    required this.reference,
    required this.summitDetails,
    required this.comments,
  });

  String get associationCode =>
      reference.contains('/') ? reference.split('/').first : reference;

  String? get band =>
      bandFromKhz((double.tryParse(freqMhz) ?? 0) * 1000);

  String get freqDisplay {
    final mhz = double.tryParse(freqMhz) ?? 0;
    if (mhz > 0) return '${mhz.toStringAsFixed(3)} MHz';
    return '$freqMhz MHz';
  }

  factory SotaSpotModel.fromJson(Map<String, dynamic> json) {
    final assoc = json['associationCode']?.toString() ?? '';
    final summit = json['summitCode']?.toString() ?? '';
    final ref = assoc.isNotEmpty && summit.isNotEmpty
        ? '$assoc/$summit'
        : (assoc + summit);
    return SotaSpotModel(
      id: json['id'] as int? ?? 0,
      spotTime: parseUtcLoose(json['timeStamp']?.toString()),
      activator: json['activatorCallsign']?.toString() ?? '',
      spotter: json['callsign']?.toString() ?? '',
      freqMhz: json['frequency']?.toString() ?? '0',
      mode: json['mode']?.toString() ?? '',
      reference: ref,
      summitDetails: json['summitDetails']?.toString() ?? '',
      comments: json['comments']?.toString() ?? '',
    );
  }
}

class SotaSpotFilter {
  final String? band;
  final String? mode;
  final String? association;
  final bool newestFirst;

  const SotaSpotFilter({
    this.band,
    this.mode,
    this.association,
    this.newestFirst = true,
  });

  SotaSpotFilter copyWith({
    Object? band = _s,
    Object? mode = _s,
    Object? association = _s,
    bool? newestFirst,
  }) =>
      SotaSpotFilter(
        band: band == _s ? this.band : band as String?,
        mode: mode == _s ? this.mode : mode as String?,
        association:
            association == _s ? this.association : association as String?,
        newestFirst: newestFirst ?? this.newestFirst,
      );

  bool get hasFilters => band != null || mode != null || association != null;
  static const _s = Object();
}
