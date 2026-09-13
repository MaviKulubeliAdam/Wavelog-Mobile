import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/error_l10n.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../data/models/contest_model.dart';
import '../../../providers/remote_datasource_provider.dart';

// ── Provider ──────────────────────────────────────────────────────────────────

final contestSessionsProvider =
    FutureProvider.autoDispose<List<ContestSession>>((ref) async {
  return ref.read(wavelogRemoteDatasourceProvider).getContestSessions();
});

// ── Screen ────────────────────────────────────────────────────────────────────

class ContestSessionListScreen extends ConsumerWidget {
  const ContestSessionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final sessions = ref.watch(contestSessionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.contestSessions),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(contestSessionsProvider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/contest/new');
          ref.invalidate(contestSessionsProvider);
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.newSession),
      ),
      body: sessions.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(localizeError(context, e))),
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.emoji_events_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.outline),
                    const SizedBox(height: 16),
                    Text(l10n.noContestSessions,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      l10n.noContestSessionsHint,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(contestSessionsProvider),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (ctx, i) => _SessionCard(
                session: list[i],
                onChanged: () => ref.invalidate(contestSessionsProvider),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Session card ──────────────────────────────────────────────────────────────

class _SessionCard extends ConsumerWidget {
  final ContestSession session;
  final VoidCallback onChanged;
  const _SessionCard({required this.session, required this.onChanged});

  Future<void> _openLog(BuildContext context) async {
    await context.push('/contest/log', extra: session);
    onChanged();
  }

  Future<void> _openEdit(BuildContext context) async {
    await context.push('/contest/new', extra: session);
    onChanged();
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteSession),
        content: Text(l10n.deleteSessionConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await ref
          .read(wavelogRemoteDatasourceProvider)
          .deleteContestSession(session.id);
      onChanged();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${context.l10n.error}: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final dateFmt = DateFormat('dd.MM.yy HH:mm');
    final active = session.isActive;

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _openLog(context),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                  child: Text(
                    session.contestName.isNotEmpty
                        ? session.contestName
                        : session.adifName,
                    style: tt.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: active
                        ? Colors.green.withValues(alpha: 0.15)
                        : cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: active
                          ? Colors.green.withValues(alpha: 0.5)
                          : cs.outline.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    active ? l10n.contestSessionActive : l10n.contestSessionEnded,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: active ? Colors.green : cs.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                PopupMenuButton<_CardAction>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (action) {
                    switch (action) {
                      case _CardAction.log:
                        _openLog(context);
                      case _CardAction.edit:
                        _openEdit(context);
                      case _CardAction.delete:
                        _confirmDelete(context, ref);
                    }
                  },
                  itemBuilder: (ctx) => [
                    PopupMenuItem(
                      value: _CardAction.log,
                      child: ListTile(
                        leading: const Icon(Icons.radio),
                        title: Text(l10n.openSession),
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    PopupMenuItem(
                      value: _CardAction.edit,
                      child: ListTile(
                        leading: const Icon(Icons.edit_outlined),
                        title: Text(l10n.editContestSession),
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    PopupMenuItem(
                      value: _CardAction.delete,
                      child: ListTile(
                        leading: Icon(Icons.delete_outline,
                            color: cs.error),
                        title: Text(l10n.deleteSession,
                            style: TextStyle(color: cs.error)),
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                ),
              ]),
              if (session.adifName.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(session.adifName,
                    style: tt.bodySmall
                        ?.copyWith(color: cs.primary, fontWeight: FontWeight.w500)),
              ],
              const SizedBox(height: 6),
              Row(children: [
                Icon(Icons.schedule, size: 13, color: cs.onSurfaceVariant),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    session.timeEnd != null
                        ? l10n.contestSessionDates(
                            dateFmt.format(session.timeStart.toLocal()),
                            dateFmt.format(session.timeEnd!.toLocal()),
                          )
                        : dateFmt.format(session.timeStart.toLocal()),
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.radio, size: 13, color: cs.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  l10n.qsoCount(session.qsoCount),
                  style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ]),
              if (active) ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: () => _openLog(context),
                    child: Text(l10n.openSession),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

enum _CardAction { log, edit, delete }

