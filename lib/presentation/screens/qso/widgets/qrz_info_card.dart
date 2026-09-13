import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/l10n_extension.dart';
import '../../../../data/models/callsign_lookup_model.dart';

// ── QRZ compact info card ─────────────────────────────────────────────────────

class QrzInfoCard extends StatelessWidget {
  final CallsignLookupModel info;
  const QrzInfoCard({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final hasPhoto = info.imageUrl != null && info.imageUrl!.isNotEmpty;
    final hasBasicInfo = info.name != null || info.country != null;
    final hasChips = info.dxcc != null ||
        info.gridSquare != null ||
        info.cqZone != null ||
        info.ituZone != null ||
        info.continent != null;
    final hasQsl = info.lotwMember || info.eqslMember || info.buqslMember;

    if (!hasBasicInfo && !hasPhoto && !hasChips && !hasQsl) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row: photo + name/country ──────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasPhoto) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: info.imageUrl!,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => _photoPlaceholder(cs),
                      errorWidget: (_, __, ___) => _photoPlaceholder(cs),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (info.name != null)
                        Text(
                          info.name!,
                          style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600),
                        ),
                      if (info.qth != null || info.country != null) ...[
                        const SizedBox(height: 2),
                        Row(children: [
                          if (info.flag != null && info.flag!.isNotEmpty) ...[
                            Text(info.flag!,
                                style: const TextStyle(fontSize: 14)),
                            const SizedBox(width: 4),
                          ],
                          Expanded(
                            child: Text(
                              [info.qth, info.country]
                                  .whereType<String>()
                                  .join(', '),
                              style: TextStyle(
                                  fontSize: 12, color: cs.onSurfaceVariant),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ]),
                      ],
                      if (info.workedBefore) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Colors.green.withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle_outline,
                                  size: 12, color: Colors.green),
                              const SizedBox(width: 4),
                              Text(context.l10n.workedBefore,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            // ── Info chips ─────────────────────────────────────────────
            if (hasChips) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  if (info.dxcc != null)
                    _InfoChip('DXCC', info.dxcc!, cs),
                  if (info.gridSquare != null)
                    _InfoChip('Grid', info.gridSquare!, cs),
                  if (info.cqZone != null)
                    _InfoChip('CQ', info.cqZone!, cs),
                  if (info.ituZone != null)
                    _InfoChip('ITU', info.ituZone!, cs),
                  if (info.continent != null)
                    _InfoChip(context.l10n.continent, info.continent!, cs),
                ],
              ),
            ],

            // ── QSL badges ─────────────────────────────────────────────
            if (hasQsl) ...[
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Row(children: [
                Icon(Icons.mail_outline, size: 13, color: cs.secondary),
                const SizedBox(width: 4),
                Text('QSL',
                    style: TextStyle(
                        fontSize: 12,
                        color: cs.secondary,
                        fontWeight: FontWeight.w500)),
                const SizedBox(width: 8),
                if (info.lotwMember) const _QslBadge('LoTW', Colors.blue),
                if (info.lotwMember) const SizedBox(width: 4),
                if (info.eqslMember) const _QslBadge('eQSL', Colors.orange),
                if (info.eqslMember) const SizedBox(width: 4),
                if (info.buqslMember) _QslBadge(context.l10n.bureau, Colors.purple),
              ]),
            ],

            // ── Address ────────────────────────────────────────────────
            if (info.addr1 != null) ...[
              const SizedBox(height: 6),
              Text(
                info.addr1!,
                style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
                overflow: TextOverflow.ellipsis,
              ),
            ],

            // ── Email ──────────────────────────────────────────────────
            if (info.email != null) ...[
              const SizedBox(height: 4),
              Row(children: [
                Icon(Icons.email_outlined, size: 12, color: cs.primary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    info.email!,
                    style: TextStyle(
                        fontSize: 11,
                        color: cs.primary,
                        decoration: TextDecoration.underline),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ]),
            ],
          ],
        ),
      ),
    );
  }

  Widget _photoPlaceholder(ColorScheme cs) => Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.person, size: 32, color: cs.onSurfaceVariant),
      );
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme cs;
  const _InfoChip(this.label, this.value, this.cs);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
              text: '$label ',
              style: TextStyle(
                  fontSize: 10,
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w400)),
          TextSpan(
              text: value,
              style: TextStyle(
                  fontSize: 11,
                  color: cs.onSurface,
                  fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}

class _QslBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _QslBadge(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 10, color: color, fontWeight: FontWeight.w700)),
    );
  }
}
