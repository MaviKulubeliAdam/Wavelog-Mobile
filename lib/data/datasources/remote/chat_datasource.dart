import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../models/chat_message_model.dart';

class ChatDatasource {
  final FirebaseFirestore _db;
  final FirebaseMessaging _fcm;

  ChatDatasource({FirebaseFirestore? db, FirebaseMessaging? fcm})
      : _db = db ?? FirebaseFirestore.instance,
        _fcm = fcm ?? FirebaseMessaging.instance;

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

  // Reaksiyon listesi uid ile tutuluyor (callsign ile değil) — Firestore
  // kuralı sadece request.auth.uid'in eklenip çıkarılmasına izin veriyor,
  // bu yüzden burada başka bir kimlik göndermek zaten sunucuda reddedilir.
  Future<void> toggleReaction(
    String roomId,
    String messageId,
    String emoji,
    String uid,
    bool adding,
  ) =>
      _messages(roomId).doc(messageId).update({
        'reactions.$emoji': adding
            ? FieldValue.arrayUnion([uid])
            : FieldValue.arrayRemove([uid]),
      });

  // FCM: Bu sohbet odasına yeni mesaj bildirimi almak isteyen
  Future<void> subscribeToRoom(String roomId) =>
      _fcm.subscribeToTopic('chat_room_$roomId');

  Future<void> unsubscribeFromRoom(String roomId) =>
      _fcm.unsubscribeFromTopic('chat_room_$roomId');
}
