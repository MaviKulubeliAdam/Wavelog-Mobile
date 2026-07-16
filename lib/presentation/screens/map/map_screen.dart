import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../data/models/qso_model.dart';

// Computes map markers from the local Hive QSO cache
final _mapMarkersProvider = FutureProvider<List<_QsoMarker>>((ref) async {
  final box = Hive.box<QsoModel>('qso_cache');
  final markers = <_QsoMarker>[];
  final seen = <String>{};

  for (final qso in box.values) {
    final grid = qso.gridSquare;
    if (grid == null || grid.length < 4) continue;
    final ll = _gridToLatLng(grid);
    if (ll == null) continue;

    // Deduplicate by callsign so one dot per worked station
    if (seen.add(qso.callsign)) {
      markers.add(_QsoMarker(
        callsign: qso.callsign,
        point: ll,
        band: qso.band,
        mode: qso.mode,
      ));
    }
  }
  return markers;
});

LatLng? _gridToLatLng(String grid) {
  try {
    final g = grid.toUpperCase();
    final lon = (g.codeUnitAt(0) - 65) * 20.0 - 180.0 +
        (g.codeUnitAt(2) - 48) * 2.0 + 1.0;
    final lat = (g.codeUnitAt(1) - 65) * 10.0 - 90.0 +
        (g.codeUnitAt(3) - 48) * 1.0 + 0.5;
    if (lat < -90 || lat > 90 || lon < -180 || lon > 180) return null;
    return LatLng(lat, lon);
  } catch (_) {
    return null;
  }
}

class _QsoMarker {
  final String callsign;
  final LatLng point;
  final String band;
  final String mode;
  const _QsoMarker({
    required this.callsign,
    required this.point,
    required this.band,
    required this.mode,
  });
}

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final markersAsync = ref.watch(_mapMarkersProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.mapTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(_mapMarkersProvider),
          ),
        ],
      ),
      body: markersAsync.when(
        data: (data) {
          if (data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map_outlined, size: 64,
                      color: cs.onSurface.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text(l10n.mapNoData,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.5))),
                ],
              ),
            );
          }
          return Stack(
            children: [
              FlutterMap(
                options: const MapOptions(
                  initialCenter: LatLng(30, 15),
                  initialZoom: 2,
                  minZoom: 1,
                  maxZoom: 10,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.wavelog_mobile',
                    maxZoom: 19,
                  ),
                  MarkerLayer(
                    markers: data.map((m) => Marker(
                      point: m.point,
                      width: 24,
                      height: 24,
                      child: GestureDetector(
                        onTap: () => _showCallsignInfo(context, m),
                        child: Container(
                          decoration: BoxDecoration(
                            color: cs.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white, width: 1.5),
                          ),
                          child: Icon(Icons.radio,
                              size: 12, color: cs.onPrimary),
                        ),
                      ),
                    )).toList(),
                  ),
                ],
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: cs.surface.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  child: Text(
                    l10n.mapStationCount(data.length),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }

  void _showCallsignInfo(BuildContext context, _QsoMarker m) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(m.callsign,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text('${m.band} · ${m.mode}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
