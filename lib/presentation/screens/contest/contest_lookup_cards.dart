import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../data/models/callsign_lookup_model.dart';
import '../../../providers/lookup_provider.dart';

// Callsign lookup presentation for the contest log screen — compact card
// (phone, inline under the callsign field) and full card (tablet side panel).
// Presentation-only: no state/provider mutation, data flows in via constructor.

// ── Compact lookup card (phone) ───────────────────────────────────────────────

class CompactLookupCard extends StatelessWidget {
  final CallsignLookupModel info;
  const CompactLookupCard({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasName = info.name != null && info.name!.isNotEmpty;
    final hasLocation = info.country != null || info.qth != null;
    if (!hasName && !hasLocation) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.outline.withValues(alpha: 0.3)),
      ),
      child: Row(children: [
        if (info.flag != null && info.flag!.isNotEmpty) ...[
          Text(info.flag!, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasName)
                Text(info.name!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    overflow: TextOverflow.ellipsis),
              if (hasLocation)
                Text(
                  [info.qth, info.country]
                      .whereType<String>()
                      .join(', '),
                  style: TextStyle(
                      fontSize: 12, color: cs.onSurfaceVariant),
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
        if (info.workedBefore) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.green.withValues(alpha: 0.4)),
            ),
            child: const Text('B4',
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.green,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ]),
    );
  }
}

// ── Tablet info panel ─────────────────────────────────────────────────────────

class ContestInfoPanel extends ConsumerWidget {
  final String callsign;
  const ContestInfoPanel({super.key, required this.callsign});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs    = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    if (callsign.length < 3) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person_search_outlined,
                  size: 72, color: cs.outlineVariant),
              const SizedBox(height: 16),
              Text(
                context.l10n.counterStation,
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    }

    final lookupAsync = ref.watch(callsignInfoProvider(callsign));

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 16, 16, 16),
      children: [
        Row(children: [
          Icon(Icons.radio, size: 16, color: cs.primary),
          const SizedBox(width: 6),
          Text(
            callsign,
            style: theme.textTheme.titleLarge?.copyWith(
              fontFamily: kMonoFontFamily,
              fontWeight: FontWeight.bold,
              color: cs.primary,
              letterSpacing: 1.5,
            ),
          ),
        ]),
        const SizedBox(height: 12),
        lookupAsync.when(
          loading: () => const LinearProgressIndicator(minHeight: 2),
          error: (_, __) => const SizedBox.shrink(),
          data: (info) => FullLookupCard(info: info),
        ),
      ],
    );
  }
}

// ── Full lookup card (tablet) ─────────────────────────────────────────────────

class FullLookupCard extends StatelessWidget {
  final CallsignLookupModel info;
  const FullLookupCard({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final cs    = Theme.of(context).colorScheme;
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
            // ── Photo + name/country ───────────────────────────────────
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
                    LookupInfoChip('DXCC', info.dxcc!, cs),
                  if (info.gridSquare != null)
                    LookupInfoChip('Grid', info.gridSquare!, cs),
                  if (info.cqZone != null)
                    LookupInfoChip('CQ', info.cqZone!, cs),
                  if (info.ituZone != null)
                    LookupInfoChip('ITU', info.ituZone!, cs),
                  if (info.continent != null)
                    LookupInfoChip(context.l10n.continent, info.continent!, cs),
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
                if (info.lotwMember) const QslMemberBadge('LoTW', Colors.blue),
                if (info.lotwMember) const SizedBox(width: 4),
                if (info.eqslMember) const QslMemberBadge('eQSL', Colors.orange),
                if (info.eqslMember) const SizedBox(width: 4),
                if (info.buqslMember)
                  QslMemberBadge(context.l10n.bureau, Colors.purple),
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

class LookupInfoChip extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme cs;
  const LookupInfoChip(this.label, this.value, this.cs, {super.key});

  @override
  Widget build(BuildContext context) => Container(
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

class QslMemberBadge extends StatelessWidget {
  final String label;
  final Color color;
  const QslMemberBadge(this.label, this.color, {super.key});

  @override
  Widget build(BuildContext context) => Container(
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
