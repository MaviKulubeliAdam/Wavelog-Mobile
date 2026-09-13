import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../../../data/models/callsign_lookup_model.dart';
import '../../../../data/models/station_model.dart';
import '../../../../providers/lookup_provider.dart';
import '../../../../providers/qso_provider.dart';
import '../../../../providers/settings_provider.dart';
import '../../../../providers/station_provider.dart';
import 'logbook_summary_card.dart';
import 'previous_qsos_card.dart';
import 'qrz_info_card.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// TABLET INFO PANEL
// ═══════════════════════════════════════════════════════════════════════════════

class QsoTabletInfoPanel extends ConsumerWidget {
  final String callsign;
  const QsoTabletInfoPanel({super.key, required this.callsign});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    if (callsign.length < 3) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(12, 16, 16, 16),
        children: [
          // ── Placeholder ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person_search_outlined,
                    size: 72, color: cs.outlineVariant),
                const SizedBox(height: 20),
                Text(context.l10n.counterStation,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: cs.onSurfaceVariant)),
                const SizedBox(height: 8),
                Text(
                  context.l10n.counterStationHint,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),

          // ── Son QSO'lar ──────────────────────────────────────────
          const LogbookSummaryCard(),
        ],
      );
    }

    final lookupAsync = ref.watch(callsignInfoProvider(callsign));
    final previousAsync = ref.watch(previousQsosByCallsignProvider(callsign));

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 16, 16, 16),
      children: [
        // ── Callsign header ──────────────────────────────────────────
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

        // ── QRZ info ────────────────────────────────────────────────
        lookupAsync.when(
          loading: () => const LinearProgressIndicator(minHeight: 2),
          error: (_, __) => const SizedBox.shrink(),
          data: (info) => Column(
            children: [
              QrzInfoCard(info: info),
              const SizedBox(height: 12),
              _QsoMapCard(info: info),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // ── Son QSO'lar ──────────────────────────────────────────────
        const LogbookSummaryCard(),

        const SizedBox(height: 12),

        // ── Previous QSOs with this callsign ────────────────────────
        previousAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (qsos) =>
              qsos.isEmpty ? const SizedBox.shrink() : PreviousQsosCard(qsos: qsos),
        ),
      ],
    );
  }
}

// ── QSO map card (tablet) ────────────────────────────────────────────────────

LatLng? _maidenheadToLatLng(String grid) {
  try {
    final g = grid.toUpperCase();
    if (g.length < 4) return null;
    double lon = (g.codeUnitAt(0) - 65) * 20.0 - 180.0
               + (g.codeUnitAt(2) - 48) * 2.0;
    double lat = (g.codeUnitAt(1) - 65) * 10.0 - 90.0
               + (g.codeUnitAt(3) - 48) * 1.0;
    if (g.length >= 6) {
      lon += (g.codeUnitAt(4) - 65) / 12.0 + 1.0 / 24.0;
      lat += (g.codeUnitAt(5) - 65) / 24.0 + 1.0 / 48.0;
    } else {
      lon += 1.0;
      lat += 0.5;
    }
    if (lat < -90 || lat > 90 || lon < -180 || lon > 180) return null;
    return LatLng(lat, lon);
  } catch (_) {
    return null;
  }
}


class _QsoMapCard extends ConsumerWidget {
  final CallsignLookupModel info;
  const _QsoMapCard({required this.info});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final settings = ref.watch(settingsProvider);
    final stations = ref.watch(stationProvider).valueOrNull ?? [];

    StationModel? myStation;
    try {
      myStation = stations.firstWhere(
          (s) => s.id == settings.activeStationProfileId);
    } catch (_) {
      myStation = stations.isNotEmpty ? stations.first : null;
    }
    final myGrid = myStation?.gridSquare;
    final remoteGrid = info.gridSquare;

    if (myGrid == null || myGrid.length < 4) return const SizedBox.shrink();
    if (remoteGrid == null || remoteGrid.length < 4) return const SizedBox.shrink();

    final myPos     = _maidenheadToLatLng(myGrid);
    final remotePos = _maidenheadToLatLng(remoteGrid);
    if (myPos == null || remotePos == null) return const SizedBox.shrink();

    final distKm = const Distance().as(LengthUnit.Kilometer, myPos, remotePos);
    final bounds = LatLngBounds.fromPoints([myPos, remotePos]);

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          SizedBox(
            height: 240,
            child: FlutterMap(
              options: MapOptions(
                initialCameraFit: CameraFit.bounds(
                  bounds: bounds,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 24),
                ),
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.none,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.wavelog_mobile',
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [myPos, remotePos],
                      color: Colors.red.withValues(alpha: 0.85),
                      strokeWidth: 2.0,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: myPos,
                      width: 22,
                      height: 22,
                      child: const Icon(Icons.star,
                          color: Colors.amber, size: 22),
                    ),
                    Marker(
                      point: remotePos,
                      width: 14,
                      height: 14,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(children: [
              Icon(Icons.straighten, size: 14, color: cs.primary),
              const SizedBox(width: 4),
              Text(
                '${distKm.round()} km',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: cs.primary),
              ),
              const SizedBox(width: 12),
              Icon(Icons.grid_on, size: 13, color: cs.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(remoteGrid,
                  style: TextStyle(
                      fontSize: 12, color: cs.onSurfaceVariant)),
            ]),
          ),
        ],
      ),
    );
  }
}
