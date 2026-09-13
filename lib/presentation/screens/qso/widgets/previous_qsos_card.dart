import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../../../data/models/qso_model.dart';
import '../../../../providers/qso_provider.dart';

// ── Previous QSOs card (tablet right panel) ───────────────────────────────────

class PreviousQsosCard extends StatelessWidget {
  final List<QsoModel> qsos;
  const PreviousQsosCard({super.key, required this.qsos});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final displayed = qsos.take(15).toList();

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.history, size: 15, color: cs.primary),
              const SizedBox(width: 6),
              Text(
                context.l10n.previousQsosCount(qsos.length),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: cs.primary,
                ),
              ),
            ]),
            const Divider(height: 14),
            ...displayed.map((q) => _QsoHistoryRow(qso: q, cs: cs)),
            if (qsos.length > 15)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  context.l10n.morePreviousQsos(qsos.length - 15),
                  style:
                      TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _QsoHistoryRow extends StatelessWidget {
  final QsoModel qso;
  final ColorScheme cs;
  const _QsoHistoryRow({required this.qso, required this.cs});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd.MM.yyyy').format(qso.dateTimeOn.toLocal());
    final time = DateFormat('HH:mm').format(qso.dateTimeOn.toUtc());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.radio_button_unchecked, size: 8, color: cs.primary),
          const SizedBox(width: 8),
          // Date + time
          SizedBox(
            width: 90,
            child: Text(
              '$date\n$time UTC',
              style: const TextStyle(fontSize: 11, fontFamily: kMonoFontFamily),
            ),
          ),
          const SizedBox(width: 6),
          // Band badge
          _HistoryBadge(
              qso.band, cs.primaryContainer, cs.onPrimaryContainer),
          const SizedBox(width: 4),
          // Mode badge
          _HistoryBadge(
              qso.mode, cs.tertiaryContainer, cs.onTertiaryContainer),
          const SizedBox(width: 6),
          // RST
          if (qso.rstSent.isNotEmpty)
            Text(
              qso.rstSent,
              style: TextStyle(fontSize: 10, color: cs.onSurfaceVariant),
            ),
          // Sync indicator
          const Spacer(),
          if (!qso.synced)
            const Icon(Icons.cloud_off, size: 12, color: kOnAir),
        ],
      ),
    );
  }
}

class _HistoryBadge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  const _HistoryBadge(this.label, this.bg, this.fg);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: fg),
      ),
    );
  }
}

// ── Inline previous QSOs (phone layout only) ──────────────────────────────────

class InlinePreviousQsosCard extends ConsumerWidget {
  final String callsign;
  const InlinePreviousQsosCard({super.key, required this.callsign});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(previousQsosByCallsignProvider(callsign));
    return async.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (qsos) {
        if (qsos.isEmpty) return const SizedBox.shrink();
        final displayed = qsos.take(5).toList();
        final cs = Theme.of(context).colorScheme;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            margin: EdgeInsets.zero,
            color: cs.surfaceContainerLow,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.history, size: 14, color: cs.primary),
                    const SizedBox(width: 6),
                    Text(
                      context.l10n.previousQsosWithCallsign(callsign),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      context.l10n.totalQsos(qsos.length),
                      style:
                          TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
                    ),
                  ]),
                  const Divider(height: 10),
                  ...displayed.map((q) => _InlineQsoRow(qso: q, cs: cs)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InlineQsoRow extends StatelessWidget {
  final QsoModel qso;
  final ColorScheme cs;
  const _InlineQsoRow({required this.qso, required this.cs});

  @override
  Widget build(BuildContext context) {
    final dateStr =
        DateFormat('dd.MM.yy HH:mm').format(qso.dateTimeOn.toUtc());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(Icons.radio_button_unchecked, size: 7, color: cs.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$dateStr UTC',
              style: const TextStyle(fontSize: 11, fontFamily: kMonoFontFamily),
            ),
          ),
          _HistoryBadge(qso.band, cs.primaryContainer, cs.onPrimaryContainer),
          const SizedBox(width: 4),
          _HistoryBadge(
              qso.mode, cs.tertiaryContainer, cs.onTertiaryContainer),
          if (qso.freqMhz != null) ...[
            const SizedBox(width: 6),
            Text(
              qso.freqMhz!.toStringAsFixed(3),
              style: TextStyle(fontSize: 10, color: cs.onSurfaceVariant),
            ),
          ],
          if (qso.rstSent.isNotEmpty) ...[
            const SizedBox(width: 6),
            Text(
              qso.rstSent,
              style: TextStyle(fontSize: 10, color: cs.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}
