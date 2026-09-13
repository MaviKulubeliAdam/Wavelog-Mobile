import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../../../data/models/qso_model.dart';
import '../../../../providers/qso_provider.dart';

// ── Logbook özeti kartı (telefon düzeni) ──────────────────────────────────────
// Bugünün yerel QSO sayısını ve son 5 QSO'yu gösterir (çağrı işaretinden bağımsız).

class LogbookSummaryCard extends ConsumerWidget {
  const LogbookSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final async = ref.watch(logbookSummaryProvider);
    return async.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (summary) {
        final todayCount = summary.todayCount;
        final last5 = summary.last5;
        if (last5.isEmpty && todayCount == 0) return const SizedBox.shrink();
        final cs = Theme.of(context).colorScheme;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Card(
            margin: EdgeInsets.zero,
            color: cs.surfaceContainerLow,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Başlık satırı ──────────────────────────────────────
                  Row(children: [
                    Icon(Icons.list_alt, size: 14, color: cs.primary),
                    const SizedBox(width: 6),
                    Text(
                      l.logbookSummaryTitle,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: cs.primary),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        l.todayQsoCount(todayCount),
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: cs.onPrimaryContainer),
                      ),
                    ),
                  ]),
                  if (last5.isNotEmpty) ...[
                    const Divider(height: 8),
                    // ── Sütun başlıkları ──────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(children: [
                        Expanded(
                          flex: 24,
                          child: Text(l.colDateTime,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: cs.onSurfaceVariant)),
                        ),
                        Expanded(
                          flex: 28,
                          child: Text('QSO',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: cs.onSurfaceVariant)),
                        ),
                        Expanded(
                          flex: 12,
                          child: Text('Mod',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: cs.onSurfaceVariant)),
                        ),
                        Expanded(
                          flex: 12,
                          child: Text(l.colRstSent,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: cs.onSurfaceVariant)),
                        ),
                        Expanded(
                          flex: 12,
                          child: Text(l.colRstRcvd,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: cs.onSurfaceVariant)),
                        ),
                        Expanded(
                          flex: 12,
                          child: Text('Band',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: cs.onSurfaceVariant)),
                        ),
                      ]),
                    ),
                    ...last5.map((q) => _LogbookRow(qso: q, cs: cs)),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LogbookRow extends StatelessWidget {
  final QsoModel qso;
  final ColorScheme cs;
  const _LogbookRow({required this.qso, required this.cs});

  @override
  Widget build(BuildContext context) {
    final dt = qso.dateTimeOn.toUtc();
    final dateStr = DateFormat('dd/MM/yy HH:mm').format(dt);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          // Tarih/Saat
          Expanded(
            flex: 24,
            child: Text(
              dateStr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 10,
                  fontFamily: kMonoFontFamily,
                  color: cs.onSurfaceVariant),
            ),
          ),
          // QSO (çağrı işareti)
          Expanded(
            flex: 28,
            child: Text(
              qso.callsign,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  fontFamily: kMonoFontFamily,
                  color: cs.primary),
            ),
          ),
          // Mod
          Expanded(
            flex: 12,
            child: Text(
              qso.mode,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 10, color: cs.onSurface),
            ),
          ),
          // RST (G) — gönderilen
          Expanded(
            flex: 12,
            child: Text(
              qso.rstSent,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10,
                  fontFamily: kMonoFontFamily,
                  color: cs.onSurface),
            ),
          ),
          // RST (A) — alınan
          Expanded(
            flex: 12,
            child: Text(
              qso.rstRcvd,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10,
                  fontFamily: kMonoFontFamily,
                  color: cs.onSurface),
            ),
          ),
          // Band
          Expanded(
            flex: 12,
            child: Text(
              qso.band,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 10,
                  color: cs.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}
