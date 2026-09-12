import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String id;
  final String uid;
  final String callsign;
  final String text;
  final DateTime timestamp;
  final DateTime? editedAt;
  final Map<String, List<String>> reactions;

  const ChatMessageModel({
    required this.id,
    required this.uid,
    required this.callsign,
    required this.text,
    required this.timestamp,
    this.editedAt,
    this.reactions = const {},
  });

  bool get isEdited => editedAt != null;

  factory ChatMessageModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    final rawReactions = d['reactions'] as Map<String, dynamic>?;
    return ChatMessageModel(
      id: doc.id,
      uid: d['uid'] as String? ?? '',
      callsign: d['callsign'] as String? ?? '',
      text: d['text'] as String? ?? '',
      timestamp: (d['timestamp'] as Timestamp?)?.toDate().toUtc() ??
          DateTime.now().toUtc(),
      editedAt: (d['editedAt'] as Timestamp?)?.toDate().toUtc(),
      reactions: rawReactions == null
          ? const {}
          : rawReactions.map(
              (emoji, callsigns) =>
                  MapEntry(emoji, List<String>.from(callsigns as List)),
            ),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'uid': uid,
    'callsign': callsign.toUpperCase(),
    'text': text,
    'timestamp': Timestamp.fromDate(timestamp),
    if (editedAt != null) 'editedAt': Timestamp.fromDate(editedAt!),
  };
}
