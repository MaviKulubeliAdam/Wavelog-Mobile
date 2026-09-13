import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';

// Session-status chrome for the contest log screen — the running-score header
// bar and the recent-QSO list row. Presentation-only: no state/provider
// mutation, data flows in via constructor and callbacks flow back out.

// ── Logged QSO entry (in-memory recent list) ──────────────────────────────────

class LoggedQso {
  final String callsign;
  final DateTime time;
  final int serialSent;
  final String serialRcvd;
  final String gridRcvd;
  final String exchangeRcvd;

  const LoggedQso({
    required this.callsign,
    required this.time,
    required this.serialSent,
    required this.serialRcvd,
    required this.gridRcvd,
    required this.exchangeRcvd,
  });
}

// ── Session info bar (running score header) ────────────────────────────────────

class ContestSessionBar extends StatelessWidget {
  final String contestId;
  final String band;
  final String mode;
  final int serialSent;
  final VoidCallback? onTap;

  const ContestSessionBar({
    super.key,
    required this.contestId,
    required this.band,
    required this.mode,
    required this.serialSent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: cs.surfaceContainerHighest,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(children: [
          Expanded(
            child: Wrap(
              spacing: 8,
              children: [
                if (contestId.isNotEmpty) SessionChip(label: contestId, color: cs.primary),
                SessionChip(label: band,  color: cs.secondary),
                SessionChip(label: mode,  color: cs.tertiary),
              ],
            ),
          ),
          Text(
            '# ${serialSent.toString().padLeft(3, '0')}',
            style: tt.titleMedium?.copyWith(
              fontFamily: kMonoFontFamily,
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: 4),
            Icon(Icons.edit, size: 14, color: cs.onSurfaceVariant),
          ],
        ]),
      ),
    );
  }
}

class SessionChip extends StatelessWidget {
  final String label;
  final Color color;
  const SessionChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: color)),
      );
}

// ── Recent QSO tile ───────────────────────────────────────────────────────────

class RecentQsoTile extends StatelessWidget {
  final LoggedQso qso;
  final bool showGrid;
  final bool showExch;
  const RecentQsoTile(
      {super.key, required this.qso, required this.showGrid, required this.showExch});

  @override
  Widget build(BuildContext context) {
    final cs      = Theme.of(context).colorScheme;
    final tt      = Theme.of(context).textTheme;
    final timeFmt = DateFormat('HHmm');
    const mono    = TextStyle(fontFamily: kMonoFontFamily);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(children: [
        SizedBox(
          width: 38,
          child: Text(timeFmt.format(qso.time.toLocal()),
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant).merge(mono)),
        ),
        Expanded(
          flex: 3,
          child: Text(qso.callsign,
              style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.bold).merge(mono)),
        ),
        SizedBox(
          width: 36,
          child: Text(qso.serialSent.toString().padLeft(3, '0'),
              style: tt.bodySmall?.copyWith(color: cs.primary).merge(mono)),
        ),
        SizedBox(
          width: 36,
          child: Text(qso.serialRcvd,
              style: tt.bodySmall?.copyWith(color: cs.secondary).merge(mono)),
        ),
        if (showGrid)
          Expanded(
            flex: 2,
            child: Text(qso.gridRcvd,
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant).merge(mono)),
          ),
        if (showExch)
          Expanded(
            flex: 2,
            child: Text(qso.exchangeRcvd,
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
          ),
      ]),
    );
  }
}
