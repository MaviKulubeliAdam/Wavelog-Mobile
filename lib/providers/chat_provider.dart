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

// ─── Okunma zamanı takibi (okunmamış sayaç rozetleri için) ──────────────────

class LastReadNotifier extends AsyncNotifier<Map<String, DateTime>> {
  static const _key = 'wl_chat_last_read';

  @override
  Future<Map<String, DateTime>> build() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    final map = <String, DateTime>{};
    for (final entry in raw) {
      final parts = entry.split('|');
      if (parts.length != 2) continue;
      final ms = int.tryParse(parts[1]);
      if (ms == null) continue;
      map[parts[0]] = DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
    }
    return map;
  }

  Future<void> markRead(String roomId) async {
    final current = state.valueOrNull ?? {};
    final updated = {...current, roomId: DateTime.now().toUtc()};
    state = AsyncValue.data(updated);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      updated.entries
          .map((e) => '${e.key}|${e.value.millisecondsSinceEpoch}')
          .toList(),
    );
  }

  DateTime? lastReadOf(String roomId) => state.valueOrNull?[roomId];
}

final lastReadProvider =
    AsyncNotifierProvider<LastReadNotifier, Map<String, DateTime>>(
        LastReadNotifier.new);

/// Bir odadaki okunmamış (kendi mesajların hariç) mesaj sayısı.
final unreadCountProvider = Provider.family<int, String>((ref, roomId) {
  final messages = ref.watch(chatMessagesProvider(roomId)).valueOrNull ?? [];
  final lastRead = ref.watch(lastReadProvider).valueOrNull?[roomId];
  final myCallsign =
      ref.watch(settingsProvider).activeStationCallsign?.toUpperCase() ?? '';

  if (lastRead == null) {
    return messages
        .where((m) => m.callsign.toUpperCase() != myCallsign)
        .length;
  }
  return messages
      .where((m) =>
          m.callsign.toUpperCase() != myCallsign &&
          m.timestamp.isAfter(lastRead))
      .length;
});

/// Takip edilen tüm odalardaki toplam okunmamış mesaj sayısı
/// (drawer'daki Topluluk rozeti için).
final totalUnreadChatProvider = Provider<int>((ref) {
  final subscribed = ref.watch(subscribedChatRoomsProvider).valueOrNull ?? {};
  var total = 0;
  for (final roomId in subscribed) {
    total += ref.watch(unreadCountProvider(roomId));
  }
  return total;
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
    final uid = ref.read(firebaseAuthProvider).currentUser?.uid;
    if (uid == null) return;
    final alreadyReacted = (message.reactions[emoji] ?? []).contains(uid);
    await ref.read(chatDatasourceProvider).toggleReaction(
          roomId,
          message.id,
          emoji,
          uid,
          !alreadyReacted,
        );
  }
}

final chatNotifierProvider = NotifierProvider<ChatNotifier, void>(
  ChatNotifier.new,
);
