import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/callsign_flags.dart';
import '../../../data/models/qso_model.dart';

class QsoListTile extends StatelessWidget {
  final QsoModel qso;
  final VoidCallback? onTap;

  const QsoListTile({super.key, required this.qso, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dt = qso.dateTimeOn.toUtc();
    final dateStr = DateFormat('dd.MM.yy HH:mm').format(dt);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ListTile(
        onTap: onTap,
        leading: _QsoLeading(qso: qso, theme: theme),
        title: Row(
          children: [
            Text(
              qso.callsign.toUpperCase(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(width: 8),
            if (!qso.synced)
              const Icon(Icons.cloud_off, size: 14, color: Colors.orange),
          ],
        ),
        subtitle: Text(
          '$dateStr  •  ${qso.band}  •  ${qso.mode}',
          style: theme.textTheme.bodySmall,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              qso.rstSent,
              style: theme.textTheme.labelMedium?.copyWith(
                fontFamily: 'monospace',
              ),
            ),
            Text(
              qso.rstRcvd,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.secondary,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QsoLeading extends StatelessWidget {
  final QsoModel qso;
  final ThemeData theme;
  const _QsoLeading({required this.qso, required this.theme});

  @override
  Widget build(BuildContext context) {
    final info = flagForCallsign(qso.callsign, qso.country);

    if (info != null) {
      return SizedBox(
        width: 44,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(info.$1, style: const TextStyle(fontSize: 24)),
            Text(
              info.$2,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    // Fallback — mod badge
    return CircleAvatar(
      backgroundColor: theme.colorScheme.primaryContainer,
      child: Text(
        qso.mode.length > 3 ? qso.mode.substring(0, 3) : qso.mode,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
