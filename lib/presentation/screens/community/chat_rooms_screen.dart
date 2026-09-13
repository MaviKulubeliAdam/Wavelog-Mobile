import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../providers/chat_provider.dart';

class ChatRoomsScreen extends ConsumerWidget {
  const ChatRoomsScreen({super.key});

  static const _rooms = [
    _Room('general', '🌐', null), // null = uses l10n — common language: English
    _Room('tr',      '🇹🇷', 'Türkçe'),
    _Room('de',      '🇩🇪', 'Deutsch'),
    _Room('fr',      '🇫🇷', 'Français'),
    _Room('it',      '🇮🇹', 'Italiano'),
    _Room('pl',      '🇵🇱', 'Polski'),
    _Room('ja',      '🇯🇵', '日本語'),
    _Room('ko',      '🇰🇷', '한국어'),
    _Room('ru',      '🇷🇺', 'Русский'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscribedAsync = ref.watch(subscribedChatRoomsProvider);
    final subscribed = subscribedAsync.valueOrNull ?? const <String>{};

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.chatRooms)),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _rooms.length,
        separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
        itemBuilder: (context, i) {
          final room = _rooms[i];
          final name = room.id == 'general'
              ? context.l10n.chatGeneral
              : room.name!;
          final subtitle = room.id == 'general'
              ? context.l10n.chatGeneralSubtitle
              : null;
          final isFollowing = subscribed.contains(room.id);
          final unread =
              isFollowing ? ref.watch(unreadCountProvider(room.id)) : 0;
          return ListTile(
            leading: Badge(
              isLabelVisible: unread > 0,
              label: Text('$unread'),
              child: Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Text(room.flag, style: const TextStyle(fontSize: 22)),
              ),
            ),
            title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: subtitle != null ? Text(subtitle) : null,
            trailing: IconButton(
              icon: Icon(
                isFollowing
                    ? Icons.notifications_active
                    : Icons.notifications_none,
                color: isFollowing
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              tooltip: isFollowing
                  ? context.l10n.chatUnfollow
                  : context.l10n.chatFollow,
              onPressed: () =>
                  ref.read(chatNotifierProvider.notifier).toggleFollow(room.id),
            ),
            onTap: () => context.push(
              '/community/chat/${room.id}',
              extra: name,
            ),
          );
        },
      ),
    );
  }
}

class _Room {
  final String id;
  final String flag;
  final String? name;
  const _Room(this.id, this.flag, this.name);
}
