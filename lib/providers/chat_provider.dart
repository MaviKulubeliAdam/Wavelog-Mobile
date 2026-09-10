import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/utils/profanity_filter.dart';
import '../data/datasources/remote/chat_datasource.dart';
import '../data/models/chat_message_model.dart';
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
    final filtered = filterProfanity(text.trim(), roomId);
    if (filtered.isEmpty) return null;

    final callsign = ref.read(settingsProvider).activeStationCallsign ?? '';
    if (callsign.isEmpty) return 'No active station callsign found.';

    final message = ChatMessageModel(
      id: '',
      callsign: callsign,
      text: filtered,
      timestamp: DateTime.now().toUtc(),
    );
    await ref.read(chatDatasourceProvider).sendMessage(roomId, message);
    return null;
  }

  Future<void> editMessage(String roomId, String messageId, String newText) async {
    final filtered = filterProfanity(newText.trim(), roomId);
    if (filtered.isEmpty) return;
    await ref.read(chatDatasourceProvider).editMessage(roomId, messageId, filtered);
  }

  Future<void> deleteMessage(String roomId, String messageId) =>
      ref.read(chatDatasourceProvider).deleteMessage(roomId, messageId);
}

final chatNotifierProvider = NotifierProvider<ChatNotifier, void>(
  ChatNotifier.new,
);
