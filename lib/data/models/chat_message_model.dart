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

  /// Reactions içeriği tamamen kullanıcı tarafından güncellenebilir bir alan
  /// (Firestore kuralı yalnızca kendi uid'ini ekleyip çıkarmaya izin veriyor,
  /// ama yine de kötü biçimli veriye karşı savunmalı ayrıştırıyoruz — tek bir
  /// bozuk mesaj yüzünden tüm oda akışının çökmesini istemiyoruz).
  static Map<String, List<String>> _parseReactions(dynamic raw) {
    if (raw is! Map) return const {};
    final result = <String, List<String>>{};
    for (final entry in raw.entries) {
      final emoji = entry.key;
      final value = entry.value;
      if (emoji is! String || value is! List) continue;
      result[emoji] = value.whereType<String>().toList();
    }
    return result;
  }

  factory ChatMessageModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return ChatMessageModel(
      id: doc.id,
      uid: d['uid'] as String? ?? '',
      callsign: d['callsign'] as String? ?? '',
      text: d['text'] as String? ?? '',
      timestamp: (d['timestamp'] as Timestamp?)?.toDate().toUtc() ??
          DateTime.now().toUtc(),
      editedAt: (d['editedAt'] as Timestamp?)?.toDate().toUtc(),
      reactions: _parseReactions(d['reactions']),
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
