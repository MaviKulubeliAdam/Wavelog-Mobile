import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/chat_message_model.dart';

class ChatDatasource {
  final FirebaseFirestore _db;

  ChatDatasource({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _messages(String roomId) =>
      _db.collection('chat_rooms').doc(roomId).collection('messages');

  Stream<List<ChatMessageModel>> watchMessages(String roomId) =>
      _messages(roomId)
          .orderBy('timestamp', descending: false)
          .limitToLast(100)
          .snapshots()
          .map((s) => s.docs.map(ChatMessageModel.fromFirestore).toList());

  Future<void> sendMessage(String roomId, ChatMessageModel message) =>
      _messages(roomId).add(message.toFirestore());

  Future<void> editMessage(String roomId, String messageId, String newText) =>
      _messages(roomId).doc(messageId).update({
        'text': newText,
        'editedAt': FieldValue.serverTimestamp(),
      });

  Future<void> deleteMessage(String roomId, String messageId) =>
      _messages(roomId).doc(messageId).delete();
}
