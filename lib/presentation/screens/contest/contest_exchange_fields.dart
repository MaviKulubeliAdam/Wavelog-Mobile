import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/l10n_extension.dart';

/// Serial / gridsquare / exchange row group for the contest log entry form.
///
/// Presentation-only: each section is shown/hidden by the flags the parent's
/// session setup already computed, and every edit is reported back through a
/// callback — no state, provider or timer logic lives here.
class ContestExchangeFields extends StatelessWidget {
  final bool showSerial;
  final bool showGridsquare;
  final bool showExchange;
  final int serialSent;
  final TextEditingController serialRcvdCtrl;
  final TextEditingController gridsquareSentCtrl;
  final TextEditingController gridsquareRcvdCtrl;
  final TextEditingController exchangeSentCtrl;
  final TextEditingController exchangeRcvdCtrl;
  final ValueChanged<String> onGridSentChanged;
  final ValueChanged<String> onExchangeSentChanged;
  final VoidCallback onSubmitLog;

  const ContestExchangeFields({
    super.key,
    required this.showSerial,
    required this.showGridsquare,
    required this.showExchange,
    required this.serialSent,
    required this.serialRcvdCtrl,
    required this.gridsquareSentCtrl,
    required this.gridsquareRcvdCtrl,
    required this.exchangeSentCtrl,
    required this.exchangeRcvdCtrl,
    required this.onGridSentChanged,
    required this.onExchangeSentChanged,
    required this.onSubmitLog,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs   = Theme.of(context).colorScheme;
    final tt   = Theme.of(context).textTheme;

    return Column(
      children: [
        // ── Serial row ─────────────────────────────────────────────
        if (showSerial) ...[
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l10n.serialSentLabel,
                  border: const OutlineInputBorder(),
                ),
                child: Text(
                  serialSent.toString().padLeft(3, '0'),
                  style: tt.titleMedium?.copyWith(
                    fontFamily: kMonoFontFamily,
                    fontWeight: FontWeight.bold,
                    color: cs.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: serialRcvdCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textInputAction:
                    showExchange ? TextInputAction.next : TextInputAction.done,
                style: const TextStyle(fontFamily: kMonoFontFamily),
                decoration: InputDecoration(
                  labelText: l10n.serialRcvdLabel,
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: showExchange ? null : (_) => onSubmitLog(),
              ),
            ),
          ]),
        ],

        // ── Gridsquare row ────────────────────────────────────────
        if (showGridsquare) ...[
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
              child: TextField(
                controller: gridsquareSentCtrl,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.next,
                style: const TextStyle(fontFamily: kMonoFontFamily),
                decoration: InputDecoration(
                  labelText: context.l10n.gridSentLabel,
                  border: const OutlineInputBorder(),
                ),
                onChanged: onGridSentChanged,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: gridsquareRcvdCtrl,
                textCapitalization: TextCapitalization.characters,
                textInputAction:
                    showExchange ? TextInputAction.next : TextInputAction.done,
                style: const TextStyle(fontFamily: kMonoFontFamily),
                decoration: InputDecoration(
                  labelText: context.l10n.gridRcvdLabel,
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: showExchange ? null : (_) => onSubmitLog(),
              ),
            ),
          ]),
        ],

        // ── Exchange row ───────────────────────────────────────────
        if (showExchange) ...[
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
              child: TextField(
                controller: exchangeSentCtrl,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: l10n.exchangeSentLabel,
                  border: const OutlineInputBorder(),
                ),
                onChanged: onExchangeSentChanged,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: exchangeRcvdCtrl,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: l10n.exchangeRcvdLabel,
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (_) => onSubmitLog(),
              ),
            ),
          ]),
        ],
      ],
    );
  }
}
