import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/utils/error_l10n.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../data/models/contest_event_model.dart';
import '../../../providers/contest_calendar_provider.dart';

class ContestCalendarScreen extends ConsumerWidget {
  const ContestCalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final async = ref.watch(contestCalendarProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.contestCalendarTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.contestCalendarRefresh,
            onPressed: () => ref.invalidate(contestCalendarProvider),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(
          message: localizeError(context, e),
          onRetry: () => ref.invalidate(contestCalendarProvider),
        ),
        data: (events) => _CalendarBody(events: events),
      ),
    );
  }
}

// ── Body ──────────────────────────────────────────────────────────────────────

class _CalendarBody extends ConsumerWidget {
  final List<ContestEvent> events;
  const _CalendarBody({required this.events});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final today = events.where((e) => e.isToday && !e.isPast).toList();
    final week = events.where((e) => e.isThisWeek && !e.isPast).toList();
    final upcoming = events
        .where((e) => !e.isToday && !e.isThisWeek && !e.isPast)
        .toList();
    final past = events.where((e) => e.isPast).toList();

    if (events.isEmpty) {
      return Center(child: Text(l10n.contestCalendarNoContests));
    }

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(contestCalendarProvider),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          if (today.isNotEmpty) ...[
            _SectionHeader(label: l10n.contestCalendarToday, color: Colors.red.shade400),
            ...today.map((e) => _EventTile(event: e, highlight: true)),
          ],
          if (week.isNotEmpty) ...[
            _SectionHeader(label: l10n.contestCalendarThisWeek, color: Colors.orange.shade400),
            ...week.map((e) => _EventTile(event: e)),
          ],
          if (upcoming.isNotEmpty) ...[
            _SectionHeader(label: l10n.contestCalendarUpcoming, color: Theme.of(context).colorScheme.primary),
            ...upcoming.map((e) => _EventTile(event: e)),
          ],
          if (past.isNotEmpty) ...[
            _SectionHeader(label: l10n.contestCalendarRecentlyPast, color: Theme.of(context).colorScheme.outline),
            ...past.take(10).map((e) => _EventTile(event: e, dimmed: true)),
          ],
        ],
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final Color color;
  const _SectionHeader({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 18,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
          ),
        ],
      ),
    );
  }
}

// ── Event tile ────────────────────────────────────────────────────────────────

class _EventTile extends StatelessWidget {
  final ContestEvent event;
  final bool highlight;
  final bool dimmed;
  const _EventTile({required this.event, this.highlight = false, this.dimmed = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final timeStr = _formatTimeRange(event);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      elevation: highlight ? 2 : 0,
      color: highlight
          ? cs.errorContainer.withValues(alpha: 0.5)
          : dimmed
              ? cs.surfaceContainerHighest.withValues(alpha: 0.4)
              : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: event.link.isNotEmpty
            ? () => launchUrl(Uri.parse(event.link), mode: LaunchMode.externalApplication)
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              if (event.startUtc != null)
                _DateBadge(date: event.startUtc!, dimmed: dimmed),
              if (event.startUtc != null) const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: dimmed ? cs.onSurface.withValues(alpha: 0.5) : null,
                          ),
                    ),
                    if (timeStr.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        timeStr,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant.withValues(alpha: dimmed ? 0.5 : 1.0),
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              if (event.link.isNotEmpty)
                Icon(Icons.open_in_new, size: 14, color: cs.onSurfaceVariant.withValues(alpha: 0.5)),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimeRange(ContestEvent e) {
    if (e.startUtc == null) return e.description;
    final fmt = DateFormat('MMM d');
    final timeFmt = DateFormat('HHmm\'Z\'');
    if (e.endUtc != null) {
      final sameDay = e.startUtc!.day == e.endUtc!.day &&
          e.startUtc!.month == e.endUtc!.month;
      if (sameDay) {
        return '${fmt.format(e.startUtc!)}  ${timeFmt.format(e.startUtc!)}–${timeFmt.format(e.endUtc!)}';
      }
      return '${fmt.format(e.startUtc!)} ${timeFmt.format(e.startUtc!)} – ${fmt.format(e.endUtc!)} ${timeFmt.format(e.endUtc!)}';
    }
    return fmt.format(e.startUtc!);
  }
}

// ── Date badge ────────────────────────────────────────────────────────────────

class _DateBadge extends StatelessWidget {
  final DateTime date;
  final bool dimmed;
  const _DateBadge({required this.date, this.dimmed = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final alpha = dimmed ? 0.4 : 1.0;
    return Container(
      width: 38,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withValues(alpha: dimmed ? 0.3 : 0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DateFormat('MMM').format(date).toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: cs.onPrimaryContainer.withValues(alpha: alpha),
              letterSpacing: 0.5,
            ),
          ),
          Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.1,
              color: cs.onPrimaryContainer.withValues(alpha: alpha),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Error view ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_outlined, size: 56, color: cs.error),
            const SizedBox(height: 16),
            Text(
              l10n.contestCalendarLoadError,
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(l10n.contestCalendarRetry),
            ),
          ],
        ),
      ),
    );
  }
}
