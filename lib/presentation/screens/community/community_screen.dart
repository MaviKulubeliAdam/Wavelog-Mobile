import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../data/models/planned_activation_model.dart';
import '../../../providers/community_provider.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Topluluk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alert_outlined),
            tooltip: 'Aktivasyon Duyur',
            onPressed: () => context.push('/community/plan'),
          ),
        ],
      ),
      body: const _ActivationList(),
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
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48),
            const SizedBox(height: 12),
            Text('Bağlantı hatası', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('$e', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
      data: (activations) {
        if (activations.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.radio_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('Henüz planlanan aktivasyon yok'),
                SizedBox(height: 8),
                Text(
                  'İlk duyuruyu sen yap!',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async =>
              ref.refresh(upcomingActivationsProvider),
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
        .contains(activation.id);
    final cs = Theme.of(context).colorScheme;
    final timeStr = DateFormat('dd MMM HH:mm').format(
      activation.scheduledAt.toLocal(),
    );
    final isNow = activation.scheduledAt
        .difference(DateTime.now().toUtc())
        .abs()
        .inMinutes < 60;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Üst şerit — tip rengi
          Container(
            height: 4,
            color: _typeColor(activation.type, cs),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Tip rozeti
                    _TypeBadge(type: activation.type),
                    const SizedBox(width: 8),
                    // Callsign
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
                    // Saat
                    Row(
                      children: [
                        if (isNow)
                          Container(
                            width: 8, height: 8,
                            margin: const EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                        Text(
                          timeStr,
                          style: TextStyle(
                            fontSize: 12,
                            color: isNow ? Colors.green : cs.onSurfaceVariant,
                            fontWeight: isNow
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (activation.referenceTitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    activation.referenceTitle!,
                    style: TextStyle(
                      fontSize: 12,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                // Bandlar ve modlar
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
                      '${activation.subscriberCount} abone',
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
                        subscribed ? 'Abonelikten çık' : 'Bildir beni',
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
      case ActivationType.sota: return Colors.orange;
      case ActivationType.pota: return Colors.green;
      case ActivationType.general: return cs.primary;
    }
  }
}

class _TypeBadge extends StatelessWidget {
  final ActivationType type;
  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;
    switch (type) {
      case ActivationType.sota:
        label = 'SOTA'; color = Colors.orange;
      case ActivationType.pota:
        label = 'POTA'; color = Colors.green;
      case ActivationType.general:
        label = 'GENEL';
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
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: color),
      ),
    );
  }
}
