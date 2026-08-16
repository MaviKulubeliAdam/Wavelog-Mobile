import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../data/models/callsign_lookup_model.dart';
import '../../../providers/lookup_provider.dart';

class CallsignInfoCard extends ConsumerWidget {
  final CallsignLookupModel result;
  final VoidCallback? onLogQso;

  const CallsignInfoCard({super.key, required this.result, this.onLogQso});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final qslStatus = ref
        .watch(callsignQslStatusProvider(result.callsign))
        .valueOrNull;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(context, theme),
            const Divider(height: 24),
            _infoGrid(context),
            if (result.qslManager != null || result.lotwMember || result.eqslMember || result.buqslMember || result.qslConfirmed) ...[
              const SizedBox(height: 12),
              _qslSection(context, theme),
            ],
            if (qslStatus != null && qslStatus.hasAny) ...[
              const Divider(height: 20),
              _qslStatusSection(context, theme, qslStatus),
            ],
            if (result.workedBefore &&
                (result.lastWorkedDate != null || result.lastWorkedBand != null)) ...[
              const Divider(height: 20),
              Text(context.l10n.lastQsoLabel, style: theme.textTheme.labelLarge),
              const SizedBox(height: 4),
              Text(
                [
                  if (result.lastWorkedDate != null) result.lastWorkedDate,
                  if (result.lastWorkedBand != null) result.lastWorkedBand,
                  if (result.lastWorkedMode != null) result.lastWorkedMode,
                ].join('  •  '),
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.secondary),
              ),
            ],
            if (onLogQso != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onLogQso,
                  icon: const Icon(Icons.add),
                  label: Text(context.l10n.makeQso),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile photo
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: result.imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    result.imageUrl!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _avatarPlaceholder(theme),
                  ),
                )
              : _avatarPlaceholder(theme),
        ),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        result.callsign,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (result.workedBefore)
                    Chip(
                      label: Text(context.l10n.workedBefore,
                          style: const TextStyle(fontSize: 11)),
                      backgroundColor: Colors.green.withValues(alpha: 0.2),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
              if (result.name != null) ...[
                const SizedBox(height: 2),
                Text(result.name!, style: theme.textTheme.titleMedium),
              ],
              if (result.addr1 != null) ...[
                const SizedBox(height: 2),
                Text(
                  result.addr1!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.secondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (result.qth != null || result.country != null) ...[
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.location_on,
                        size: 14, color: theme.colorScheme.secondary),
                    const SizedBox(width: 2),
                    if (result.flag != null && result.flag!.isNotEmpty) ...[
                      Text(result.flag!,
                          style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                    ],
                    Expanded(
                      child: Text(
                        [
                          if (result.qth != null) result.qth,
                          if (result.country != null) result.country,
                        ].join(', '),
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.colorScheme.secondary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _avatarPlaceholder(ThemeData theme) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.person,
          size: 40, color: theme.colorScheme.onSurfaceVariant),
    );
  }

  Widget _infoGrid(BuildContext context) {
    final l10n = context.l10n;
    final items = <(String, String?)>[
      ('DXCC', result.dxcc),
      (l10n.continent, result.continent),
      ('CQ', result.cqZone),
      ('ITU', result.ituZone),
      (l10n.gridSquare, result.gridSquare),
      ('E-Mail', result.email),
    ].where((e) => e.$2 != null && e.$2!.isNotEmpty).toList();

    if (items.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 20,
      runSpacing: 10,
      children: items
          .map((e) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(e.$1,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          )),
                  Text(e.$2!,
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ))
          .toList(),
    );
  }

  Widget _qslSection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('QSL', style: theme.textTheme.labelLarge),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: [
            if (result.qslConfirmed)
              _qslChip(context.l10n.dxccLegendConfirmed, Colors.green),
            if (result.lotwMember)
              _qslChip('LoTW', Colors.blue),
            if (result.eqslMember)
              _qslChip('eQSL', Colors.orange),
            if (result.buqslMember)
              _qslChip(context.l10n.bureau, Colors.purple),
          ],
        ),
        if (result.qslManager != null) ...[
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${context.l10n.qslMethod}: ',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.secondary)),
              Expanded(
                child: Text(
                  result.qslManager!,
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _qslStatusSection(
      BuildContext context, ThemeData theme, CallsignQslStatus s) {
    final cs = theme.colorScheme;

    // Rows: [label, sent, rcvd]
    final rows = <(String, bool, bool)>[
      ('Kağıt QSL', s.qslSent,  s.qslRcvd),
      ('LoTW',      s.lotwSent, s.lotwRcvd),
      ('eQSL',      s.eqslSent, s.eqslRcvd),
    ];
    final hasQrz = s.qrzUploaded;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.qslStatus, style: theme.textTheme.labelLarge),
        const SizedBox(height: 6),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              children: [
                const SizedBox.shrink(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(context.l10n.qslSent,
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: cs.secondary),
                      textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(context.l10n.qslRcvd,
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: cs.secondary),
                      textAlign: TextAlign.center),
                ),
              ],
            ),
            for (final row in rows)
              if (row.$2 || row.$3)
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(row.$1,
                        style: theme.textTheme.bodySmall),
                  ),
                  Icon(
                    row.$2 ? Icons.check_circle : Icons.radio_button_unchecked,
                    size: 16,
                    color: row.$2 ? Colors.green : cs.outlineVariant,
                  ),
                  Icon(
                    row.$3 ? Icons.check_circle : Icons.radio_button_unchecked,
                    size: 16,
                    color: row.$3 ? Colors.green : cs.outlineVariant,
                  ),
                ]),
          ],
        ),
        if (hasQrz) ...[
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.cloud_done, size: 14, color: Colors.green),
            const SizedBox(width: 4),
            Text('QRZ uploaded',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: Colors.green)),
          ]),
        ],
      ],
    );
  }

  Widget _qslChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }
}
