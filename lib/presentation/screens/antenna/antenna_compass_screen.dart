import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/utils/geo_utils.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/utils/maidenhead.dart';

class AntennaCompassScreen extends ConsumerStatefulWidget {
  const AntennaCompassScreen({super.key});

  @override
  ConsumerState<AntennaCompassScreen> createState() =>
      _AntennaCompassScreenState();
}

class _AntennaCompassScreenState extends ConsumerState<AntennaCompassScreen> {
  final _gridCtrl = TextEditingController();
  StreamSubscription<CompassEvent>? _compassSub;

  double? _heading;
  double? _myLat, _myLon;
  double? _targetAz;
  double? _distanceKm;
  bool _shortPath = true;
  bool _gpsLoading = false;
  String? _error;
  bool _compassAvailable = true;

  @override
  void initState() {
    super.initState();
    _compassSub = FlutterCompass.events?.listen((e) {
      if (!mounted) return;
      if (e.heading == null) {
        setState(() => _compassAvailable = false);
      } else {
        setState(() { _heading = e.heading; _compassAvailable = true; });
      }
    });
    if (_compassSub == null) setState(() => _compassAvailable = false);
    _fetchGps();
  }

  Future<void> _fetchGps() async {
    setState(() { _gpsLoading = true; _error = null; });
    try {
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        setState(() => _gpsLoading = false);
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      if (!mounted) return;
      setState(() {
        _myLat = pos.latitude;
        _myLon = pos.longitude;
        _gpsLoading = false;
      });
      // Pre-fill my own grid as hint
      final myGrid = latLngToGrid(pos.latitude, pos.longitude);
      if (myGrid != null && _gridCtrl.text.isEmpty) {
        // Leave empty — user types the TARGET grid
      }
      _calcAzimuth();
    } catch (e) {
      if (mounted) setState(() { _gpsLoading = false; _error = e.toString(); });
    }
  }

  void _calcAzimuth() {
    final grid = _gridCtrl.text.trim().toUpperCase();
    if (grid.length < 4) return;
    if (_myLat == null) {
      setState(() => _error = _gpsLoading
          ? context.l10n.gpsLocating
          : context.l10n.gpsUnavailable);
      return;
    }
    final target = maidenheadToLatLon(grid);
    if (target == null) {
      setState(() => _error = context.l10n.invalidGrid);
      return;
    }
    final az = calculateAzimuth(_myLat!, _myLon!, target.lat, target.lon);
    final dist = calculateDistance(_myLat!, _myLon!, target.lat, target.lon);
    setState(() { _targetAz = az; _distanceKm = dist; _error = null; });
  }

  @override
  void dispose() {
    _compassSub?.cancel();
    _gridCtrl.dispose();
    super.dispose();
  }

  double get _activeAz =>
      _shortPath ? (_targetAz ?? 0) : ((_targetAz ?? 0) + 180) % 360;

  bool get _isLocked =>
      _heading != null &&
      _targetAz != null &&
      ((_activeAz - _heading! + 360) % 360).abs() <= 10;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.antennaCompassTitle)),
      body: Column(
        children: [
          // ── Grid input ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _gridCtrl,
                    decoration: InputDecoration(
                      labelText: l10n.targetGrid,
                      hintText: 'KN34AB',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.grid_on_outlined),
                      suffixIcon: _gridCtrl.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _gridCtrl.clear();
                                setState(() { _targetAz = null; _distanceKm = null; });
                              },
                            )
                          : null,
                    ),
                    textCapitalization: TextCapitalization.characters,
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _calcAzimuth(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _calcAzimuth,
                  icon: const Icon(Icons.explore),
                  label: Text(l10n.calculate),
                ),
              ],
            ),
          ),

          // ── GPS acquiring indicator ──────────────────────────────────────
          if (_gpsLoading)
            const LinearProgressIndicator(minHeight: 2),

          // ── Short / Long path toggle ────────────────────────────────────
          if (_targetAz != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SegmentedButton<bool>(
                segments: [
                  ButtonSegment(
                      value: true,
                      label: Text(l10n.shortPath),
                      icon: const Icon(Icons.arrow_downward, size: 16)),
                  ButtonSegment(
                      value: false,
                      label: Text(l10n.longPath),
                      icon: const Icon(Icons.arrow_upward, size: 16)),
                ],
                selected: {_shortPath},
                onSelectionChanged: (v) => setState(() => _shortPath = v.first),
              ),
            ),

          // ── Error message ────────────────────────────────────────────────
          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(_error!,
                  style: TextStyle(color: cs.error, fontSize: 12)),
            ),

          // ── Compass ─────────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: !_compassAvailable
                      ? _StaticBearing(azimuth: _targetAz, shortPath: _shortPath)
                      : _heading == null
                          ? const CircularProgressIndicator()
                          : CustomPaint(
                              painter: _CompassPainter(
                                heading: _heading!,
                                targetAzimuth: _targetAz,
                                shortPath: _shortPath,
                                locked: _isLocked,
                              ),
                            ),
                ),
              ),
            ),
          ),

          // ── Info row ─────────────────────────────────────────────────────
          if (_targetAz != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _InfoTile(
                    icon: Icons.explore,
                    label: l10n.azimuth,
                    value: '${_activeAz.toInt()}°',
                    highlight: _isLocked,
                  ),
                  _InfoTile(
                    icon: Icons.straighten,
                    label: l10n.distance,
                    value: formatDistance(_distanceKm ?? 0),
                  ),
                  _InfoTile(
                    icon: Icons.navigation,
                    label: l10n.myHeading,
                    value: _heading != null ? '${_heading!.toInt()}°' : '--',
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ── Static bearing display (when compass sensor not available) ────────────────

class _StaticBearing extends StatelessWidget {
  final double? azimuth;
  final bool shortPath;
  const _StaticBearing({this.azimuth, required this.shortPath});

  @override
  Widget build(BuildContext context) {
    final az = azimuth != null
        ? (shortPath ? azimuth! : (azimuth! + 180) % 360)
        : null;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.explore_off, size: 48,
            color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(height: 12),
        Text('No compass sensor', style: Theme.of(context).textTheme.bodySmall),
        if (az != null) ...[
          const SizedBox(height: 16),
          Text('${az.toInt()}°',
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ],
    );
  }
}

// ── Info tile ─────────────────────────────────────────────────────────────────

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool highlight;
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = highlight ? Colors.greenAccent : cs.onSurface;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 2),
        Text(label,
            style: TextStyle(fontSize: 10, color: cs.onSurfaceVariant)),
        Text(value,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}

// ── Compass Painter ────────────────────────────────────────────────────────────

class _CompassPainter extends CustomPainter {
  final double heading;
  final double? targetAzimuth;
  final bool shortPath;
  final bool locked;

  const _CompassPainter({
    required this.heading,
    this.targetAzimuth,
    required this.shortPath,
    required this.locked,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 * 0.9;

    // ── Background ───────────────────────────────────────────────────────
    canvas.drawCircle(
      center, size.width / 2,
      Paint()..color = const Color(0xFF0D0D1A),
    );
    canvas.drawCircle(
      center, size.width / 2,
      Paint()
        ..color = const Color(0xFF1E1E3A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.04,
    );

    canvas.save();
    canvas.translate(center.dx, center.dy);
    // Rotate ring so "up" = where phone is facing
    canvas.rotate(-heading * pi / 180);

    // ── Tick marks ───────────────────────────────────────────────────────
    for (var i = 0; i < 360; i += 5) {
      final angle = i * pi / 180;
      final isMajor = i % 30 == 0;
      final innerR = isMajor ? r * 0.78 : r * 0.87;
      final dx = sin(angle);
      final dy = -cos(angle);
      canvas.drawLine(
        Offset(dx * innerR, dy * innerR),
        Offset(dx * r, dy * r),
        Paint()
          ..color = isMajor
              ? const Color(0xFF8888BB)
              : const Color(0xFF444466)
          ..strokeWidth = isMajor ? 2 : 1,
      );
    }

    // ── Degree labels every 30° ──────────────────────────────────────────
    for (var i = 0; i < 360; i += 30) {
      final angle = i * pi / 180;
      final labelR = r * 0.68;
      final pos = Offset(sin(angle) * labelR, -cos(angle) * labelR);
      final tp = TextPainter(
        text: TextSpan(
          text: i == 0
              ? 'N'
              : i == 90
                  ? 'E'
                  : i == 180
                      ? 'S'
                      : i == 270
                          ? 'W'
                          : '$i',
          style: TextStyle(
            color: i == 0 ? const Color(0xFFFF4444) : const Color(0xFFBBBBDD),
            fontSize: i % 90 == 0 ? r * 0.16 : r * 0.09,
            fontWeight: i % 90 == 0 ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas,
          Offset(pos.dx - tp.width / 2, pos.dy - tp.height / 2));
    }

    canvas.restore();

    // ── Target arrow ─────────────────────────────────────────────────────
    if (targetAzimuth != null) {
      final az = shortPath ? targetAzimuth! : (targetAzimuth! + 180) % 360;
      final arrowAngle = (az - heading) * pi / 180;
      final arrowColor = locked ? Colors.greenAccent : const Color(0xFFFF8C00);

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(arrowAngle);

      // Shaft
      canvas.drawLine(
        Offset(0, r * 0.1),
        Offset(0, -r * 0.45),
        Paint()
          ..color = arrowColor.withValues(alpha: 0.6)
          ..strokeWidth = 3,
      );

      // Arrow head
      final tip = Offset(0, -r * 0.72);
      final path = Path()
        ..moveTo(tip.dx, tip.dy)
        ..lineTo(-r * 0.07, -r * 0.48)
        ..lineTo(r * 0.07, -r * 0.48)
        ..close();
      canvas.drawPath(path, Paint()..color = arrowColor);

      // Lock ring
      if (locked) {
        canvas.drawCircle(
          Offset(0, -r * 0.6),
          r * 0.12,
          Paint()
            ..color = Colors.greenAccent.withValues(alpha: 0.25)
            ..style = PaintingStyle.fill,
        );
      }

      canvas.restore();
    }

    // ── Fixed heading indicator triangle at top ───────────────────────────
    canvas.save();
    canvas.translate(center.dx, center.dy);
    final triPath = Path()
      ..moveTo(0, -r - 6)
      ..lineTo(-9, -r + 10)
      ..lineTo(9, -r + 10)
      ..close();
    canvas.drawPath(triPath, Paint()..color = Colors.white);
    canvas.restore();

    // ── Center dot ────────────────────────────────────────────────────────
    canvas.drawCircle(center, 7, Paint()..color = Colors.white);
    canvas.drawCircle(
        center, 4, Paint()..color = const Color(0xFF0D0D1A));
  }

  @override
  bool shouldRepaint(_CompassPainter old) =>
      old.heading != heading ||
      old.targetAzimuth != targetAzimuth ||
      old.shortPath != shortPath ||
      old.locked != locked;
}
