import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../data/models/planned_activation_model.dart';
import '../../../providers/community_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/common/empty_state.dart';
import 'chat_rooms_screen.dart';
import 'community_auth_gate.dart';
import '../../../providers/callsign_claim_provider.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final claimAsync = ref.watch(callsignClaimProvider);
    final isVerified = claimAsync.valueOrNull == ClaimState.verified;

    if (!isVerified) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.communityTitle)),
        body: const CommunityAuthGate(child: SizedBox.shrink()),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.communityTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_alert_outlined),
              tooltip: context.l10n.communityAnnounce,
              onPressed: () => context.push('/community/plan'),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                icon: const Icon(Icons.radio_outlined),
                text: context.l10n.communityActivations,
              ),
              Tab(
                icon: const Icon(Icons.chat_bubble_outline),
                text: context.l10n.communityChat,
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _ActivationList(),
            ChatRoomsScreen(),
          ],
        ),
      ),
    );
  }
}

class _ActivationList extends ConsumerWidget {
  const _ActivationList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activationsAsync = ref.watch(upcomingActivationsProvider);

    return activationsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => EmptyState(
        icon: Icons.cloud_off,
        title: 'Connection error',
        subtitle: '$e',
      ),
      data: (activations) {
        if (activations.isEmpty) {
          return EmptyState(
            icon: Icons.radio_outlined,
            title: context.l10n.communityNoActivations,
            subtitle: context.l10n.communityBeFirst,
          );
        }
        return RefreshIndicator(
          onRefresh: () async => ref.refresh(upcomingActivationsProvider),
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: activations.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) =>
                _ActivationCard(activation: activations[i]),
          ),
        );
      },
    );
  }
}

class _ActivationCard extends ConsumerWidget {
  final PlannedActivationModel activation;
  const _ActivationCard({required this.activation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscribed = ref
            .watch(subscribedActivationsProvider)
            .valueOrNull
            ?.contains(activation.id) ??
        false;
    final myCallsign =
        ref.watch(settingsProvider).activeStationCallsign ?? '';
    final isOwn = activation.callsign.toUpperCase() ==
        myCallsign.toUpperCase();
    final cs = Theme.of(context).colorScheme;
    final timeStr =
        DateFormat('dd MMM HH:mm').format(activation.scheduledAt.toLocal());
    final isNow = activation.scheduledAt
            .difference(DateTime.now().toUtc())
            .abs()
            .inMinutes <
        60;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 4, color: _typeColor(activation.type, cs)),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _TypeBadge(type: activation.type),
                    const SizedBox(width: 8),
                    Text(
                      activation.callsign,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (activation.reference != null) ...[
                      const SizedBox(width: 6),
                      Text(
                        activation.reference!,
                        style: TextStyle(color: cs.primary, fontSize: 13),
                      ),
                    ],
                    const Spacer(),
                    Row(
                      children: [
                        if (isNow)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(right: 4),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                        Text(
                          timeStr,
                          style: TextStyle(
                            fontSize: 12,
                            color: isNow ? Colors.green : cs.onSurfaceVariant,
                            fontWeight:
                                isNow ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        if (isOwn) ...[
                          const SizedBox(width: 4),
                          _OwnerMenu(activation: activation),
                        ],
                      ],
                    ),
                  ],
                ),
                if (activation.referenceTitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    activation.referenceTitle!,
                    style:
                        TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
                  ),
                ],
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    ...activation.bands.map((b) => _Chip(b, cs.primary)),
                    ...activation.modes.map((m) => _Chip(m, cs.secondary)),
                  ],
                ),
                if (activation.comment.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    activation.comment,
                    style: const TextStyle(fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.notifications_outlined,
                        size: 14, color: cs.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      context.l10n
                          .communityFollowers(activation.subscriberCount),
                      style: TextStyle(
                          fontSize: 12, color: cs.onSurfaceVariant),
                    ),
                    const Spacer(),
                    FilledButton.tonal(
                      onPressed: () => ref
                          .read(communityNotifierProvider.notifier)
                          .toggleSubscribe(activation.id),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        subscribed
                            ? context.l10n.communityUnfollow
                            : context.l10n.communityFollow,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _typeColor(ActivationType t, ColorScheme cs) {
    switch (t) {
      case ActivationType.sota:
        return Colors.orange;
      case ActivationType.pota:
        return Colors.green;
      case ActivationType.general:
        return cs.primary;
    }
  }
}

// ── Owner menu (edit / delete) ───────────────────────────────────────────────

class _OwnerMenu extends ConsumerWidget {
  final PlannedActivationModel activation;
  const _OwnerMenu({required this.activation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<_OwnerAction>(
      iconSize: 18,
      padding: EdgeInsets.zero,
      itemBuilder: (_) => [
        PopupMenuItem(
          value: _OwnerAction.edit,
          child: Row(children: [
            const Icon(Icons.edit_outlined, size: 18),
            const SizedBox(width: 8),
            Text(context.l10n.communityEditActivation),
          ]),
        ),
        PopupMenuItem(
          value: _OwnerAction.delete,
          child: Row(children: [
            Icon(Icons.delete_outline,
                size: 18,
                color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 8),
            Text(
              context.l10n.communityDeleteActivation,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ]),
        ),
      ],
      onSelected: (action) async {
        if (action == _OwnerAction.edit) {
          context.push('/community/edit', extra: activation);
        } else {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(ctx.l10n.communityDeleteActivation),
              content:
                  Text(ctx.l10n.communityDeleteActivationConfirm),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(
                      MaterialLocalizations.of(ctx).cancelButtonLabel),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor:
                          Theme.of(ctx).colorScheme.error),
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(ctx.l10n.communityDeleteActivation),
                ),
              ],
            ),
          );
          if (confirmed == true) {
            await ref
                .read(communityNotifierProvider.notifier)
                .deleteOwnActivation(activation.id);
          }
        }
      },
    );
  }
}

enum _OwnerAction { edit, delete }

// ── Shared widgets ───────────────────────────────────────────────────────────

class _TypeBadge extends StatelessWidget {
  final ActivationType type;
  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;
    switch (type) {
      case ActivationType.sota:
        label = 'SOTA';
        color = Colors.orange;
      case ActivationType.pota:
        label = 'POTA';
        color = Colors.green;
      case ActivationType.general:
        label = context.l10n.communityTypeGeneral.toUpperCase();
        color = Theme.of(context).colorScheme.primary;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, color: color)),
    );
  }
}
