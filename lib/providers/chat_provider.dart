import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

// ─── Kalıcı takip edilen oda listesi ─────────────────────────────────────────

class SubscribedChatRoomsNotifier extends AsyncNotifier<Set<String>> {
  static const _key = 'wl_subscribed_chat_rooms';

  @override
  Future<Set<String>> build() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_key) ?? []).toSet();
  }

  Future<void> _save(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, ids.toList());
  }

  Future<void> add(String roomId) async {
    final current = state.valueOrNull ?? {};
    final updated = {...current, roomId};
    state = AsyncValue.data(updated);
    await _save(updated);
  }

  Future<void> remove(String roomId) async {
    final current = state.valueOrNull ?? {};
    final updated = {...current}..remove(roomId);
    state = AsyncValue.data(updated);
    await _save(updated);
  }

  bool contains(String roomId) => state.valueOrNull?.contains(roomId) ?? false;
}

final subscribedChatRoomsProvider =
    AsyncNotifierProvider<SubscribedChatRoomsNotifier, Set<String>>(
        SubscribedChatRoomsNotifier.new);

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

  Future<void> toggleFollow(String roomId) async {
    final ds = ref.read(chatDatasourceProvider);
    final notifier = ref.read(subscribedChatRoomsProvider.notifier);

    if (notifier.contains(roomId)) {
      await ds.unsubscribeFromRoom(roomId);
      await notifier.remove(roomId);
    } else {
      await ds.subscribeToRoom(roomId);
      await notifier.add(roomId);
    }
  }

  Future<void> toggleReaction(
      String roomId, ChatMessageModel message, String emoji) async {
    final callsign = ref.read(settingsProvider).activeStationCallsign ?? '';
    if (callsign.isEmpty) return;
    final alreadyReacted = (message.reactions[emoji] ?? [])
        .map((c) => c.toUpperCase())
        .contains(callsign.toUpperCase());
    await ref.read(chatDatasourceProvider).toggleReaction(
          roomId,
          message.id,
          emoji,
          callsign,
          !alreadyReacted,
        );
  }
}

final chatNotifierProvider = NotifierProvider<ChatNotifier, void>(
  ChatNotifier.new,
);
