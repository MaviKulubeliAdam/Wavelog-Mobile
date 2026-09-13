import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/services/chat_notification_service.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../data/models/chat_message_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/chat_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/common/empty_state.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String roomId;
  final String roomName;

  const ChatScreen({
    super.key,
    required this.roomId,
    required this.roomName,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    ChatNotificationService.activeRoomId = widget.roomId;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(lastReadProvider.notifier).markRead(widget.roomId),
    );
  }

  @override
  void dispose() {
    if (ChatNotificationService.activeRoomId == widget.roomId) {
      ChatNotificationService.activeRoomId = null;
    }
    ref.read(lastReadProvider.notifier).markRead(widget.roomId);
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send() async {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    _inputCtrl.clear();
    final err = await ref
        .read(chatNotifierProvider.notifier)
        .sendMessage(widget.roomId, text);
    if (mounted) {
      setState(() => _sending = false);
      if (err != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(err == 'inappropriate'
                ? 'Message contains inappropriate content.'
                : err),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        _scrollToBottom();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatMessagesProvider(widget.roomId));
    final myCallsign =
        ref.watch(settingsProvider).activeStationCallsign ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.roomName,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            if (myCallsign.isNotEmpty)
              Text(
                myCallsign.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
              data: (messages) {
                if (messages.isEmpty) {
                  return const EmptyState(
                    icon: Icons.chat_bubble_outline,
                    title: 'İlk mesajı sen gönder!',
                  );
                }
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => _scrollToBottom());
                return _MessageList(
                  messages: messages,
                  myCallsign: myCallsign,
                  roomId: widget.roomId,
                  scrollCtrl: _scrollCtrl,
                );
              },
            ),
          ),
          if (myCallsign.isEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                context.l10n.chatNoStation,
                style: TextStyle(
                    color:
                        Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            )
          else
            _InputBar(
              controller: _inputCtrl,
              sending: _sending,
              onSend: _send,
            ),
        ],
      ),
    );
  }
}

// ── Message list with date separators ────────────────────────────────────────

class _MessageList extends StatelessWidget {
  final List<ChatMessageModel> messages;
  final String myCallsign;
  final String roomId;
  final ScrollController scrollCtrl;

  const _MessageList({
    required this.messages,
    required this.myCallsign,
    required this.roomId,
    required this.scrollCtrl,
  });

  @override
  Widget build(BuildContext context) {
    // Build flat list with optional date separators
    final items = <_ListItem>[];
    DateTime? lastDate;

    for (var i = 0; i < messages.length; i++) {
      final msg = messages[i];
      final local = msg.timestamp.toLocal();
      final msgDate = DateTime(local.year, local.month, local.day);

      if (lastDate == null || msgDate != lastDate) {
        items.add(_ListItem.dateSep(msgDate));
        lastDate = msgDate;
      }

      // Group: same sender within 5 minutes of previous message
      final prev = i > 0 ? messages[i - 1] : null;
      final isGrouped = prev != null &&
          prev.callsign.toUpperCase() == msg.callsign.toUpperCase() &&
          msg.timestamp.difference(prev.timestamp).inMinutes < 5;

      items.add(_ListItem.message(msg, isGrouped));
    }

    return ListView.builder(
      controller: scrollCtrl,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        if (item.isDateSep) {
          return _DateSeparator(date: item.date!);
        }
        final msg = item.message!;
        final isOwn =
            msg.callsign.toUpperCase() == myCallsign.toUpperCase();
        return _MessageBubble(
          message: msg,
          isOwn: isOwn,
          isGrouped: item.isGrouped,
          roomId: roomId,
          myCallsign: myCallsign,
        );
      },
    );
  }
}

class _ListItem {
  final DateTime? date;
  final ChatMessageModel? message;
  final bool isGrouped;

  const _ListItem._({this.date, this.message, this.isGrouped = false});

  bool get isDateSep => date != null;

  factory _ListItem.dateSep(DateTime d) => _ListItem._(date: d);
  factory _ListItem.message(ChatMessageModel m, bool grouped) =>
      _ListItem._(message: m, isGrouped: grouped);
}

// ── Date separator ────────────────────────────────────────────────────────────

class _DateSeparator extends StatelessWidget {
  final DateTime date;
  const _DateSeparator({required this.date});

  String _label(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    if (date == today) return context.l10n.chatToday;
    if (date == yesterday) return context.l10n.chatYesterday;
    return DateFormat('d MMMM y', context.l10n.localeName).format(date);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
              child: Divider(color: cs.outlineVariant, thickness: 0.5)),
          const SizedBox(width: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _label(context),
              style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
              child: Divider(color: cs.outlineVariant, thickness: 0.5)),
        ],
      ),
    );
  }
}

// ── Message bubble ────────────────────────────────────────────────────────────

const _kReactionEmojis = ['👍', '❤️', '😂', '😮', '😢', '🙏'];

class _MessageBubble extends ConsumerWidget {
  final ChatMessageModel message;
  final bool isOwn;
  final bool isGrouped;
  final String roomId;
  final String myCallsign;

  const _MessageBubble({
    required this.message,
    required this.isOwn,
    required this.isGrouped,
    required this.roomId,
    required this.myCallsign,
  });

  String _timeLabel(BuildContext context, DateTime ts) {
    final local = ts.toLocal();
    final now = DateTime.now();
    final isToday = local.year == now.year &&
        local.month == now.month &&
        local.day == now.day;
    final locale = context.l10n.localeName;
    return isToday
        ? DateFormat('HH:mm', locale).format(local)
        : DateFormat('d MMM HH:mm', locale).format(local);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final timeLabel = _timeLabel(context, message.timestamp);

    // Callsign initials for avatar
    final initials = message.callsign.isNotEmpty
        ? message.callsign[0].toUpperCase()
        : '?';

    // Avatar color seeded from callsign
    final avatarColor = _callsignColor(message.callsign, cs);

    Widget bubbleContent = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.72,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isOwn ? cs.primary : cs.surfaceContainerHighest,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(isOwn ? 18 : 4),
          bottomRight: Radius.circular(isOwn ? 4 : 18),
        ),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.text,
            style: TextStyle(
              fontSize: 15,
              color: isOwn ? cs.onPrimary : cs.onSurface,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                timeLabel,
                style: TextStyle(
                  fontSize: 10,
                  color: isOwn
                      ? cs.onPrimary.withValues(alpha: 0.65)
                      : cs.onSurfaceVariant,
                ),
              ),
              if (message.isEdited) ...[
                const SizedBox(width: 4),
                Text(
                  context.l10n.chatEdited,
                  style: TextStyle(
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                    color: isOwn
                        ? cs.onPrimary.withValues(alpha: 0.55)
                        : cs.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );

    // Long-press works on every message (reactions for everyone,
    // edit/delete only for own messages)
    bubbleContent = GestureDetector(
      onLongPress: () => _showOptions(context, ref),
      child: bubbleContent,
    );

    if (message.reactions.isNotEmpty) {
      bubbleContent = Column(
        crossAxisAlignment:
            isOwn ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          bubbleContent,
          const SizedBox(height: 3),
          _ReactionRow(
            message: message,
            roomId: roomId,
          ),
        ],
      );
    }

    // Top spacing: grouped messages get less padding
    final topPad = isGrouped ? 2.0 : 8.0;

    if (isOwn) {
      return Padding(
        padding: EdgeInsets.only(top: topPad, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isGrouped)
              Padding(
                padding: const EdgeInsets.only(right: 4, bottom: 3),
                child: Text(
                  message.callsign.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: cs.primary,
                  ),
                ),
              ),
            bubbleContent,
          ],
        ),
      );
    }

    // Other person's message — avatar + callsign on left
    return Padding(
      padding: EdgeInsets.only(top: topPad, bottom: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar (visible only on first message of group)
          if (!isGrouped)
            CircleAvatar(
              radius: 16,
              backgroundColor: avatarColor,
              child: Text(
                initials,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          else
            const SizedBox(width: 32),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isGrouped)
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 3),
                  child: Text(
                    message.callsign.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: avatarColor,
                    ),
                  ),
                ),
              bubbleContent,
            ],
          ),
        ],
      ),
    );
  }

  Color _callsignColor(String callsign, ColorScheme cs) {
    // Deterministic color from callsign string
    final colors = [
      Colors.teal, Colors.indigo, Colors.deepOrange,
      Colors.purple, Colors.green, Colors.blue,
      Colors.pink, Colors.cyan, Colors.amber.shade700,
    ];
    int hash = 0;
    for (final c in callsign.codeUnits) {
      hash = (hash * 31 + c) & 0xFFFFFF;
    }
    return colors[hash % colors.length];
  }

  void _showOptions(BuildContext context, WidgetRef ref) {
    // Mesaj giriş kutusu odaklıysa uzun basınca klavye açık kalıp
    // bottom sheet'in üstüne biniyordu — önce klavyeyi kapat.
    FocusScope.of(context).unfocus();
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle now comes from the central bottomSheetTheme
            // (showDragHandle: true) — no need to draw one manually here.
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _kReactionEmojis
                    .map((emoji) => InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {
                            Navigator.pop(ctx);
                            ref
                                .read(chatNotifierProvider.notifier)
                                .toggleReaction(roomId, message, emoji);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(emoji,
                                style: const TextStyle(fontSize: 26)),
                          ),
                        ))
                    .toList(),
              ),
            ),
            const Divider(height: 1),
            if (isOwn) ...[
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: Text(ctx.l10n.chatEdit),
                onTap: () {
                  Navigator.pop(ctx);
                  _showEditDialog(context, ref);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_outline,
                    color: Theme.of(ctx).colorScheme.error),
                title: Text(ctx.l10n.chatDelete,
                    style: TextStyle(
                        color: Theme.of(ctx).colorScheme.error)),
                onTap: () {
                  Navigator.pop(ctx);
                  _confirmDelete(context, ref);
                },
              ),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController(text: message.text);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.chatEdit),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          maxLines: null,
          decoration: InputDecoration(hintText: ctx.l10n.chatMessageHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (ctrl.text.trim().isNotEmpty) {
                ref.read(chatNotifierProvider.notifier).editMessage(
                      roomId, message.id, ctrl.text.trim());
              }
            },
            child: Text(ctx.l10n.chatSend),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.chatDelete),
        content: Text(ctx.l10n.chatDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error),
            onPressed: () {
              Navigator.pop(ctx);
              ref
                  .read(chatNotifierProvider.notifier)
                  .deleteMessage(roomId, message.id);
            },
            child: Text(ctx.l10n.chatDelete),
          ),
        ],
      ),
    );
  }
}

// ── Reaction pills ────────────────────────────────────────────────────────────

class _ReactionRow extends ConsumerWidget {
  final ChatMessageModel message;
  final String roomId;

  const _ReactionRow({
    required this.message,
    required this.roomId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    // Reaksiyonlar Firestore'da uid ile tutuluyor (bkz. firestore.rules) —
    // "benim mi" kontrolü de callsign değil uid üzerinden yapılmalı.
    final myUid = ref.watch(firebaseAuthProvider).currentUser?.uid;
    final entries = message.reactions.entries
        .where((e) => e.value.isNotEmpty)
        .toList();
    if (entries.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: entries.map((e) {
        final emoji = e.key;
        final count = e.value.length;
        final mine = myUid != null && e.value.contains(myUid);
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: myUid == null
              ? null
              : () => ref
                  .read(chatNotifierProvider.notifier)
                  .toggleReaction(roomId, message, emoji),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: mine
                  ? cs.primaryContainer
                  : cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: mine ? Border.all(color: cs.primary, width: 1) : null,
            ),
            child: Text('$emoji $count',
                style: const TextStyle(fontSize: 12)),
          ),
        );
      }).toList(),
    );
  }
}

// ── Input bar ─────────────────────────────────────────────────────────────────

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool sending;
  final VoidCallback onSend;

  const _InputBar({
    required this.controller,
    required this.sending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: context.l10n.chatMessageHint,
                  filled: true,
                  fillColor: cs.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              child: IconButton.filled(
                onPressed: sending ? null : onSend,
                icon: sending
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: cs.onPrimary),
                      )
                    : const Icon(Icons.send_rounded),
                tooltip: context.l10n.chatSend,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
