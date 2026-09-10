import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/utils/profanity_filter.dart' show containsProfanity;
import '../data/datasources/remote/chat_datasource.dart';
import '../data/models/chat_message_model.dart';
import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';

final chatDatasourceProvider = Provider<ChatDatasource>(
  (_) => ChatDatasource(),
);

final chatMessagesProvider =
    StreamProvider.family<List<ChatMessageModel>, String>((ref, roomId) {
  return ref.watch(chatDatasourceProvider).watchMessages(roomId);
});

class ChatNotifier extends Notifier<void> {
  @override
  void build() {}

  Future<String?> sendMessage(String roomId, String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;
    if (containsProfanity(trimmed)) return 'inappropriate';

    final callsign = ref.read(settingsProvider).activeStationCallsign ?? '';
    if (callsign.isEmpty) return 'No active station callsign found.';

    final uid = ref.read(firebaseAuthProvider).currentUser?.uid ?? '';
    if (uid.isEmpty) return 'Not signed in.';

    final message = ChatMessageModel(
      id: '',
      uid: uid,
      callsign: callsign,
      text: trimmed,
      timestamp: DateTime.now().toUtc(),
    );
    await ref.read(chatDatasourceProvider).sendMessage(roomId, message);
    return null;
  }

  Future<void> editMessage(
      String roomId, String messageId, String newText) async {
    final trimmed = newText.trim();
    if (trimmed.isEmpty || containsProfanity(trimmed)) return;
    await ref
        .read(chatDatasourceProvider)
        .editMessage(roomId, messageId, trimmed);
  }

  Future<void> deleteMessage(String roomId, String messageId) =>
      ref.read(chatDatasourceProvider).deleteMessage(roomId, messageId);
}

final chatNotifierProvider = NotifierProvider<ChatNotifier, void>(
  ChatNotifier.new,
);
