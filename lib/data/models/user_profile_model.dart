import 'dart:convert';

class UserProfileModel {
  final String id;
  final String displayName;
  final String callsign;
  final String apiKey;
  final int? defaultStationId;
  final String? defaultStationCallsign;
  final String? defaultStationName;

  const UserProfileModel({
    required this.id,
    required this.displayName,
    required this.callsign,
    required this.apiKey,
    this.defaultStationId,
    this.defaultStationCallsign,
    this.defaultStationName,
  });

  UserProfileModel copyWith({
    String? id,
    String? displayName,
    String? callsign,
    String? apiKey,
    int? defaultStationId,
    String? defaultStationCallsign,
    String? defaultStationName,
  }) =>
      UserProfileModel(
        id: id ?? this.id,
        displayName: displayName ?? this.displayName,
        callsign: callsign ?? this.callsign,
        apiKey: apiKey ?? this.apiKey,
        defaultStationId: defaultStationId ?? this.defaultStationId,
        defaultStationCallsign:
            defaultStationCallsign ?? this.defaultStationCallsign,
        defaultStationName: defaultStationName ?? this.defaultStationName,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'displayName': displayName,
        'callsign': callsign,
        'apiKey': apiKey,
        'defaultStationId': defaultStationId,
        'defaultStationCallsign': defaultStationCallsign,
        'defaultStationName': defaultStationName,
      };

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        id: json['id'] as String,
        displayName: json['displayName'] as String,
        callsign: json['callsign'] as String,
        apiKey: json['apiKey'] as String,
        defaultStationId: json['defaultStationId'] as int?,
        defaultStationCallsign: json['defaultStationCallsign'] as String?,
        defaultStationName: json['defaultStationName'] as String?,
      );

  static UserProfileModel fromJsonString(String s) =>
      UserProfileModel.fromJson(jsonDecode(s) as Map<String, dynamic>);

  String toJsonString() => jsonEncode(toJson());
}
