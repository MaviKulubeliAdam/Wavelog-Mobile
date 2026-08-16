import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/utils/error_l10n.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../data/models/qso_model.dart';

// ── Data ──────────────────────────────────────────────────────────────────────

class _QsoMarker {
  final String callsign;
  final LatLng point;
  final String band;
  final String mode;
  final String submode;
  final String rstSent;
  final String rstRcvd;
  final String name;
  final String qth;
  final String grid;
  final String country;
  final String freq;
  final String dateStr; // pre-formatted
  const _QsoMarker({
    required this.callsign,
    required this.point,
    required this.band,
    required this.mode,
    required this.submode,
    required this.rstSent,
    required this.rstRcvd,
    required this.name,
    required this.qth,
    required this.grid,
    required this.country,
    required this.freq,
    required this.dateStr,
  });
}

// Top-level: runs in isolate — no Flutter imports allowed here
List<_QsoMarker> _processQsoData(List<Map<String, String>> raw) {
  final seen = <String>{};
  final result = <_QsoMarker>[];
  for (final q in raw) {
    final callsign = q['c'] ?? '';
    if (callsign.isEmpty || !seen.add(callsign)) continue;
    final grid = q['g'] ?? '';
    if (grid.length < 4) continue;
    final ll = _gridToLatLng(grid);
    if (ll == null) continue;
    result.add(_QsoMarker(
      callsign: callsign,
      point: ll,
      band: q['b'] ?? '',
      mode: q['m'] ?? '',
      submode: q['sm'] ?? '',
      rstSent: q['rs'] ?? '',
      rstRcvd: q['rr'] ?? '',
      name: q['n'] ?? '',
      qth: q['qt'] ?? '',
      grid: grid,
      country: q['co'] ?? '',
      freq: q['f'] ?? '',
      dateStr: q['d'] ?? '',
    ));
  }
  return result;
}

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

// ── Provider ──────────────────────────────────────────────────────────────────

final _mapMarkersProvider = FutureProvider<List<_QsoMarker>>((ref) async {
  final box = Hive.box<QsoModel>('qso_cache');
  final fmt = DateFormat('dd MMM yyyy  HH:mm');
  final raw = box.values.map((q) => {
    'c': q.callsign,
    'g': q.gridSquare ?? '',
    'b': q.band,
    'm': q.mode,
    'sm': q.submode ?? '',
    'rs': q.rstSent,
    'rr': q.rstRcvd,
    'n': q.name ?? '',
    'qt': q.qth ?? '',
    'co': q.country ?? '',
    'f': q.freqMhz != null ? '${q.freqMhz!.toStringAsFixed(3)} MHz' : '',
    'd': fmt.format(q.dateTimeOn.toLocal()),
  }).toList();
  return compute(_processQsoData, raw);
});

// ── Band colours ──────────────────────────────────────────────────────────────

const _kBandColors = <String, Color>{
  '160m': Color(0xFFFF5252),
  '80m': Color(0xFFFF6D00),
  '60m': Color(0xFFFFCA28),
  '40m': Color(0xFFD4E157),
  '30m': Color(0xFF66BB6A),
  '20m': Color(0xFF26C6DA),
  '17m': Color(0xFF42A5F5),
  '15m': Color(0xFF7E57C2),
  '12m': Color(0xFFEC407A),
  '10m': Color(0xFFFF7043),
  '6m': Color(0xFF26A69A),
  '2m': Color(0xFF78909C),
};
const _kDefaultBandColor = Color(0xFF90A4AE);

Color _bandColor(String band) => _kBandColors[band] ?? _kDefaultBandColor;

// ── Screen ────────────────────────────────────────────────────────────────────

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final _mapController = MapController();
  String _bandFilter = 'All';
  _QsoMarker? _popup;
  Offset? _popupPos; // position within the map Stack

  List<_QsoMarker> _filter(List<_QsoMarker> all) =>
      _bandFilter == 'All' ? all : all.where((m) => m.band == _bandFilter).toList();

  List<String> _bands(List<_QsoMarker> all) {
    final bands = all.map((m) => m.band).where((b) => b.isNotEmpty).toSet().toList();
    const order = ['160m', '80m', '60m', '40m', '30m', '20m', '17m', '15m', '12m', '10m', '6m', '2m'];
    bands.sort((a, b) {
      final ia = order.indexOf(a);
      final ib = order.indexOf(b);
      if (ia == -1 && ib == -1) return a.compareTo(b);
      if (ia == -1) return 1;
      if (ib == -1) return -1;
      return ia.compareTo(ib);
    });
    return bands;
  }

  void _handleTap(TapPosition tapPos, LatLng tapLatLng, List<_QsoMarker> visible) {
    final zoom = _mapController.camera.zoom;
    // 24 logical-pixel tap tolerance converted to geographic degrees.
    // This keeps the hit area proportional to what's visible on screen
    // regardless of zoom level, instead of shrinking too fast at high zoom.
    final degPerPixel = 360.0 / (256.0 * pow(2.0, zoom));
    final radiusDeg = 24.0 * degPerPixel;
    final threshold = radiusDeg * radiusDeg;

    _QsoMarker? nearest;
    var best = threshold;
    for (final m in visible) {
      final dlat = m.point.latitude - tapLatLng.latitude;
      final dlon = (m.point.longitude - tapLatLng.longitude) *
          cos(m.point.latitude * pi / 180.0);
      final d = dlat * dlat + dlon * dlon;
      if (d < best) {
        best = d;
        nearest = m;
      }
    }
    setState(() {
      _popup = nearest;
      _popupPos = tapPos.relative;
    });
  }

  void _zoom(double delta) {
    final cam = _mapController.camera;
    _mapController.move(cam.center, (cam.zoom + delta).clamp(1.0, 18.0));
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final markersAsync = ref.watch(_mapMarkersProvider);
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final tileUrl = isDark
        ? 'https://basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
        : 'https://basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.mapTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              setState(() {
                _bandFilter = 'All';
                _popup = null;
              });
              ref.invalidate(_mapMarkersProvider);
            },
          ),
        ],
      ),
      body: markersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(localizeError(context, e))),
        data: (allMarkers) {
          if (allMarkers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map_outlined, size: 64, color: cs.onSurface.withValues(alpha: 0.25)),
                  const SizedBox(height: 16),
                  Text(l10n.mapNoData,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.5),
                          )),
                ],
              ),
            );
          }

          final bands = _bands(allMarkers);
          final visible = _filter(allMarkers);

          final circles = visible.map((m) => CircleMarker(
                point: m.point,
                radius: 5.5,
                color: _bandColor(m.band).withValues(alpha: 0.82),
                borderColor: Colors.white.withValues(alpha: 0.55),
                borderStrokeWidth: 1.2,
              )).toList();

          return Column(
            children: [
              // Band filter chips
              if (bands.isNotEmpty)
                SizedBox(
                  height: 44,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    children: [
                      _BandChip(
                        label: 'All',
                        color: cs.primary,
                        selected: _bandFilter == 'All',
                        onTap: () => setState(() {
                          _bandFilter = 'All';
                          _popup = null;
                        }),
                      ),
                      ...bands.map((b) => Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: _BandChip(
                              label: b,
                              color: _bandColor(b),
                              selected: _bandFilter == b,
                              onTap: () => setState(() {
                                _bandFilter = b;
                                _popup = null;
                              }),
                            ),
                          )),
                    ],
                  ),
                ),

              // Map + overlays
              Expanded(
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: const LatLng(30, 15),
                        initialZoom: 2,
                        minZoom: 1,
                        maxZoom: 18,
                        onTap: (tapPos, latLng) => _handleTap(tapPos, latLng, visible),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: tileUrl,
                          userAgentPackageName: 'com.wavelog_mobile',
                          maxZoom: 19,
                        ),
                        CircleLayer(circles: circles),
                      ],
                    ),

                    // QSO popup card
                    if (_popup != null && _popupPos != null)
                      _QsoPopup(
                        marker: _popup!,
                        tapPos: _popupPos!,
                        onClose: () => setState(() => _popup = null),
                      ),

                    // Zoom buttons — bottom-right
                    Positioned(
                      right: 12,
                      bottom: 16,
                      child: Column(
                        children: [
                          _ZoomButton(
                            icon: Icons.add,
                            onTap: () => _zoom(1),
                          ),
                          const SizedBox(height: 6),
                          _ZoomButton(
                            icon: Icons.remove,
                            onTap: () => _zoom(-1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Status bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                color: cs.surfaceContainerLow,
                child: Row(
                  children: [
                    Icon(Icons.radio, size: 13, color: cs.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Text(
                      l10n.mapStationCount(visible.length),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (_bandFilter != 'All') ...[
                      const SizedBox(width: 6),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(color: _bandColor(_bandFilter), shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _bandFilter,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: _bandColor(_bandFilter),
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                    const Spacer(),
                    Text(
                      '© CARTO  © OpenStreetMap',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.35),
                            fontSize: 9,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── QSO Popup Card ────────────────────────────────────────────────────────────

const _kPopupWidth = 240.0;
const _kPopupMaxHeight = 260.0;
const _kArrowSize = 8.0;

class _QsoPopup extends StatelessWidget {
  final _QsoMarker marker;
  final Offset tapPos;
  final VoidCallback onClose;

  const _QsoPopup({required this.marker, required this.tapPos, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final cs = Theme.of(context).colorScheme;
    final bandColor = _bandColor(marker.band);

    // Decide whether popup appears above or below the tap
    final showAbove = tapPos.dy > size.height * 0.55;
    const cardHeight = _kPopupMaxHeight;

    double left = tapPos.dx - _kPopupWidth / 2;
    left = left.clamp(8.0, size.width - _kPopupWidth - 8.0);

    final double top = showAbove
        ? tapPos.dy - cardHeight - _kArrowSize - 4
        : tapPos.dy + _kArrowSize + 4;

    return Positioned(
      left: left,
      top: top,
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!showAbove)
              _Arrow(up: true, color: cs.surfaceContainerHigh),
            Container(
              width: _kPopupWidth,
              constraints: const BoxConstraints(maxHeight: _kPopupMaxHeight),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
                    decoration: BoxDecoration(
                      color: bandColor.withValues(alpha: 0.15),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(color: bandColor, shape: BoxShape.circle),
                        ),
                        Expanded(
                          child: Text(
                            marker.callsign,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                          ),
                        ),
                        InkWell(
                          onTap: onClose,
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Icon(Icons.close, size: 16, color: cs.onSurfaceVariant),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Body
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Band + Mode row
                          Row(children: [
                            _MiniChip(label: marker.band, color: bandColor),
                            const SizedBox(width: 6),
                            _MiniChip(
                              label: marker.submode.isNotEmpty
                                  ? '${marker.mode}/${marker.submode}'
                                  : marker.mode,
                              color: cs.secondary,
                            ),
                            if (marker.freq.isNotEmpty) ...[
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  marker.freq,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: cs.onSurfaceVariant,
                                      ),
                                ),
                              ),
                            ],
                          ]),
                          const SizedBox(height: 8),

                          // RST
                          _PopupRow(
                            icon: Icons.signal_cellular_alt,
                            label: 'RST',
                            value: '${marker.rstSent} / ${marker.rstRcvd}',
                          ),

                          // Grid
                          if (marker.grid.isNotEmpty)
                            _PopupRow(icon: Icons.grid_on, label: 'Grid', value: marker.grid),

                          // Name / QTH
                          if (marker.name.isNotEmpty)
                            _PopupRow(icon: Icons.person_outline, label: 'Name', value: marker.name),
                          if (marker.qth.isNotEmpty)
                            _PopupRow(icon: Icons.location_on_outlined, label: 'QTH', value: marker.qth),
                          if (marker.country.isNotEmpty)
                            _PopupRow(icon: Icons.flag_outlined, label: 'DXCC', value: marker.country),

                          // Coords
                          _PopupRow(
                            icon: Icons.my_location,
                            label: 'Coord',
                            value: '${marker.point.latitude.toStringAsFixed(2)}°  '
                                '${marker.point.longitude.toStringAsFixed(2)}°',
                          ),

                          // Date
                          if (marker.dateStr.isNotEmpty)
                            _PopupRow(
                              icon: Icons.access_time,
                              label: 'Date',
                              value: marker.dateStr,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (showAbove)
              _Arrow(up: false, color: cs.surfaceContainerHigh),
          ],
        ),
      ),
    );
  }
}

class _Arrow extends StatelessWidget {
  final bool up;
  final Color color;
  const _Arrow({required this.up, required this.color});

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: const Size(_kArrowSize * 2, _kArrowSize),
        painter: _ArrowPainter(up: up, color: color),
      );
}

class _ArrowPainter extends CustomPainter {
  final bool up;
  final Color color;
  const _ArrowPainter({required this.up, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = ui.Paint()..color = color;
    final path = ui.Path();
    if (up) {
      path.moveTo(size.width / 2, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width / 2, size.height);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ArrowPainter old) => old.up != up || old.color != color;
}

class _PopupRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _PopupRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 13, color: cs.onSurfaceVariant),
          const SizedBox(width: 6),
          SizedBox(
            width: 38,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String label;
  final Color color;
  const _MiniChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
        ),
      );
}

// ── Zoom Buttons ──────────────────────────────────────────────────────────────

class _ZoomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ZoomButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      elevation: 3,
      shadowColor: Colors.black38,
      color: cs.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(icon, size: 20, color: cs.onSurface),
        ),
      ),
    );
  }
}

// ── Band Filter Chip ──────────────────────────────────────────────────────────

class _BandChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _BandChip({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? color : color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: selected ? 0.0 : 0.45)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : color,
          ),
        ),
      ),
    );
  }
}
