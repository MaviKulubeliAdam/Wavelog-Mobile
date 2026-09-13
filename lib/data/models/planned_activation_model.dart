import 'package:cloud_firestore/cloud_firestore.dart';

enum ActivationType { sota, pota, general }

class PlannedActivationModel {
  final String id;
  final String uid;
  final String callsign;
  final ActivationType type;
  final String? reference;      // TA/AN-001 veya TA-0001
  final String? referenceTitle; // Summit/park adı (API'den çekilen)
  final DateTime scheduledAt;   // UTC
  final List<String> bands;
  final List<String> modes;
  final String comment;
  final int subscriberCount;
  final DateTime createdAt;

  const PlannedActivationModel({
    required this.id,
    required this.uid,
    required this.callsign,
    required this.type,
    this.reference,
    this.referenceTitle,
    required this.scheduledAt,
    required this.bands,
    required this.modes,
    required this.comment,
    required this.subscriberCount,
    required this.createdAt,
  });

  bool get isSota => type == ActivationType.sota;
  bool get isPota => type == ActivationType.pota;

  bool get isUpcoming => scheduledAt.isAfter(DateTime.now().toUtc());

  String get typeLabel {
    switch (type) {
      case ActivationType.sota: return 'SOTA';
      case ActivationType.pota: return 'POTA';
      case ActivationType.general: return 'Genel';
    }
  }

  factory PlannedActivationModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return PlannedActivationModel(
      id: doc.id,
      uid: d['uid'] as String? ?? '',
      callsign: d['callsign'] as String? ?? '',
      type: _parseType(d['type'] as String?),
      reference: d['reference'] as String?,
      referenceTitle: d['referenceTitle'] as String?,
      scheduledAt: (d['scheduledAt'] as Timestamp?)?.toDate().toUtc() ??
          DateTime.now().toUtc(),
      bands: List<String>.from(d['bands'] as List? ?? []),
      modes: List<String>.from(d['modes'] as List? ?? []),
      comment: d['comment'] as String? ?? '',
      subscriberCount: d['subscriberCount'] as int? ?? 0,
      createdAt: (d['createdAt'] as Timestamp?)?.toDate().toUtc() ??
          DateTime.now().toUtc(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'uid': uid,
    'callsign': callsign.toUpperCase(),
    'type': type.name,
    'reference': reference,
    'referenceTitle': referenceTitle,
    'scheduledAt': Timestamp.fromDate(scheduledAt),
    'bands': bands,
    'modes': modes,
    'comment': comment,
    'subscriberCount': subscriberCount,
    'createdAt': Timestamp.fromDate(createdAt),
    'expiresAt': Timestamp.fromDate(scheduledAt.add(const Duration(hours: 6))),
  };

  static ActivationType _parseType(String? s) {
    switch (s) {
      case 'sota': return ActivationType.sota;
      case 'pota': return ActivationType.pota;
      default: return ActivationType.general;
    }
  }
}
