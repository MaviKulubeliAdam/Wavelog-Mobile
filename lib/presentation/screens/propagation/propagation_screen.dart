import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/error_l10n.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../data/models/solar_data_model.dart';
import '../../../providers/solar_provider.dart';

class PropagationScreen extends ConsumerWidget {
  const PropagationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final solar = ref.watch(solarDataProvider);

    return solar.when(
      data: (data) => RefreshIndicator(
        onRefresh: () async => ref.invalidate(solarDataProvider),
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            // ── Update time ───────────────────────────────────────────
            if (data.updated.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    const Icon(Icons.update, size: 14),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        l10n.lastUpdated(data.updated),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.55),
                            ),
                      ),
                    ),
                  ],
                ),
              ),

            // ── Solar index grid ──────────────────────────────────────
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 1.2,
              children: [
                _IndexCard(
                  label: 'SFI',
                  value: '${data.solarFlux}',
                  icon: Icons.wb_sunny_outlined,
                  color: _sfiColor(data.solarFlux),
                ),
                _IndexCard(
                  label: 'Sunspots',
                  value: '${data.sunspots}',
                  icon: Icons.blur_circular_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                _IndexCard(
                  label: 'Solar Wind',
                  value: '${data.solarWind} km/s',
                  icon: Icons.air,
                  color: Theme.of(context).colorScheme.primary,
                ),
                _IndexCard(
                  label: 'K-Index',
                  value: '${data.kIndex}',
                  icon: Icons.show_chart,
                  color: _kIndexColor(data.kIndex),
                ),
                _IndexCard(
                  label: 'A-Index',
                  value: '${data.aIndex}',
                  icon: Icons.trending_up,
                  color: _aIndexColor(data.aIndex),
                ),
                _IndexCard(
                  label: 'Signal Noise',
                  value: data.signalNoise.isNotEmpty
                      ? data.signalNoise
                      : '—',
                  icon: Icons.graphic_eq,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Band conditions ───────────────────────────────────────
            Text(
              l10n.bandConditions,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            _BandConditionsTable(data: data),
            const SizedBox(height: 16),

            // ── Legend ────────────────────────────────────────────────
            _Legend(l10n: l10n),
            const SizedBox(height: 12),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 48),
            const SizedBox(height: 12),
            Text(l10n.noSolarData,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                localizeError(context, e),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () => ref.invalidate(solarDataProvider),
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }

  Color _sfiColor(int sfi) {
    if (sfi >= 150) return Colors.green;
    if (sfi >= 100) return Colors.orange;
    return Colors.red;
  }

  Color _kIndexColor(int k) {
    if (k <= 2) return Colors.green;
    if (k <= 4) return Colors.orange;
    return Colors.red;
  }

  Color _aIndexColor(int a) {
    if (a <= 7) return Colors.green;
    if (a <= 15) return Colors.orange;
    return Colors.red;
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _IndexCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _IndexCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                    color: color,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                  ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _BandConditionsTable extends StatelessWidget {
  final SolarDataModel data;
  const _BandConditionsTable({required this.data});

  static const _bandOrder = ['80m-40m', '30m-20m', '17m-15m', '12m-10m'];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    // Build lookup map: band+time → condition
    final Map<String, String> condMap = {
      for (final c in data.conditions) '${c.band}|${c.time}': c.condition,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1.5),
            2: FlexColumnWidth(1.5),
          },
          children: [
            // Header row
            TableRow(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
              children: [
                _headerCell('Band', context),
                _headerCell(l10n.dayTime, context),
                _headerCell(l10n.nightTime, context),
              ],
            ),
            // Data rows
            for (final band in _bandOrder) ...[
              TableRow(
                children: [
                  _bandCell(band, context),
                  _conditionCell(
                      condMap['$band|day'] ?? '—', context, l10n),
                  _conditionCell(
                      condMap['$band|night'] ?? '—', context, l10n),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _headerCell(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _bandCell(String band, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Text(
        band,
        style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _conditionCell(
      String condition, BuildContext context, dynamic l10n) {
    final color = _conditionColor(condition);
    final label = _conditionLabel(condition, l10n);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      child: Center(
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            border: Border.all(color: color.withValues(alpha: 0.5)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Color _conditionColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'good':
        return Colors.green;
      case 'fair':
        return Colors.orange;
      case 'poor':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _conditionLabel(String condition, dynamic l10n) {
    switch (condition.toLowerCase()) {
      case 'good':
        return l10n.conditionGood as String;
      case 'fair':
        return l10n.conditionFair as String;
      case 'poor':
        return l10n.conditionPoor as String;
      default:
        return condition.isEmpty ? '—' : condition;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _Legend extends StatelessWidget {
  final dynamic l10n;
  const _Legend({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _dot(Colors.green),
        const SizedBox(width: 4),
        Text(lText(l10n.conditionGood),
            style: const TextStyle(fontSize: 11)),
        const SizedBox(width: 12),
        _dot(Colors.orange),
        const SizedBox(width: 4),
        Text(lText(l10n.conditionFair),
            style: const TextStyle(fontSize: 11)),
        const SizedBox(width: 12),
        _dot(Colors.red),
        const SizedBox(width: 4),
        Text(lText(l10n.conditionPoor),
            style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  String lText(dynamic v) => v is String ? v : v.toString();

  Widget _dot(Color color) => Container(
        width: 10,
        height: 10,
        decoration:
            BoxDecoration(color: color, shape: BoxShape.circle),
      );
}
