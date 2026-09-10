import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String id;
  final String callsign;
  final String text;
  final DateTime timestamp;
  final DateTime? editedAt;

  const ChatMessageModel({
    required this.id,
    required this.callsign,
    required this.text,
    required this.timestamp,
    this.editedAt,
  });

  bool get isEdited => editedAt != null;

  factory ChatMessageModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return ChatMessageModel(
      id: doc.id,
      callsign: d['callsign'] as String? ?? '',
      text: d['text'] as String? ?? '',
      timestamp: (d['timestamp'] as Timestamp?)?.toDate().toUtc() ??
          DateTime.now().toUtc(),
      editedAt: (d['editedAt'] as Timestamp?)?.toDate().toUtc(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'callsign': callsign.toUpperCase(),
    'text': text,
    'timestamp': Timestamp.fromDate(timestamp),
    'editedAt': editedAt != null ? Timestamp.fromDate(editedAt!) : null,
  };
}
