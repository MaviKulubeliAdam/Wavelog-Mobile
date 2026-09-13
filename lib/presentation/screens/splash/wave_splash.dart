import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Electric highlight used by loaders / focus / the splash glow.
/// Additive to the existing seed (#0EA5E9) — does not change other UI.
const Color kAccentElectric = Color(0xFF22D3EE);

/// Animated Wavelog splash built on the real brand logo.
///
///  • the logo sits dim, then a bright + glowing copy rises bottom→top
///    (dot → arcs in sequence) — a "signal acquiring / lock" feel — holds,
///    fades, and repeats.
///  • a scrolling oscilloscope sine acts as the loading indicator.
///  • a Morse-style blinking status line ("BAĞLANIYOR").
///
/// Pure Flutter, no extra packages. Ships two assets so the wordmark stays
/// legible in both themes:
///   assets/images/wavelog_logo.png        (light-gray wordmark — dark bg)
///   assets/images/wavelog_logo_light.png  (slate wordmark      — light bg)
class WaveSplash extends StatefulWidget {
  const WaveSplash({super.key, this.statusText = 'BAĞLANIYOR'});

  final String statusText;

  @override
  State<WaveSplash> createState() => _WaveSplashState();
}

class _WaveSplashState extends State<WaveSplash> with TickerProviderStateMixin {
  static const double _logoSize = 240;

  late final AnimationController _acquire =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 2600))
        ..repeat();
  late final AnimationController _sine =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))
        ..repeat();
  late final AnimationController _blink =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))
        ..repeat();

  @override
  void dispose() {
    _acquire.dispose();
    _sine.dispose();
    _blink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? kAccentElectric : Theme.of(context).colorScheme.primary;
    final asset = isDark
        ? 'assets/images/wavelog_logo.png'
        : 'assets/images/wavelog_logo_light.png';
    final dimOpacity = isDark ? 0.40 : 0.30;

    final bg = isDark
        ? const RadialGradient(
            center: Alignment(0, -0.22),
            radius: 0.95,
            colors: [Color(0xFF16294A), Color(0xFF0F172A), Color(0xFF0B1120)],
            stops: [0.0, 0.58, 1.0],
          )
        : const RadialGradient(
            center: Alignment(0, -0.22),
            radius: 0.95,
            colors: [Color(0xFFE2F1FB), Color(0xFFF1F5F9), Color(0xFFE8EEF5)],
            stops: [0.0, 0.60, 1.0],
          );

    return DecoratedBox(
      decoration: BoxDecoration(gradient: bg),
      child: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            // ── Logo with signal-acquire reveal ──────────────────────────
            SizedBox(
              width: _logoSize,
              height: _logoSize,
              child: AnimatedBuilder(
                animation: _acquire,
                builder: (context, _) {
                  final t = _acquire.value;
                  final reveal = (t / 0.42).clamp(0.0, 1.0);
                  final double bright = t < 0.82
                      ? 1.0
                      : (t < 0.92 ? (0.92 - t) / 0.10 : 0.0);
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Opacity(
                        opacity: dimOpacity,
                        child: Image.asset(asset, fit: BoxFit.contain),
                      ),
                      Opacity(
                        opacity: bright,
                        child: ClipRect(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            heightFactor: reveal,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                ImageFiltered(
                                  imageFilter:
                                      ui.ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                                  child: ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                      accent.withValues(alpha: 0.85),
                                      BlendMode.srcATop,
                                    ),
                                    child: Image.asset(asset, fit: BoxFit.contain),
                                  ),
                                ),
                                Image.asset(asset, fit: BoxFit.contain),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'MOBILE',
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 7,
                fontWeight: FontWeight.w500,
                color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
              ),
            ),
            const Spacer(),
            // ── Oscilloscope loader ──────────────────────────────────────
            SizedBox(
              width: 248,
              height: 40,
              child: AnimatedBuilder(
                animation: _sine,
                builder: (context, _) =>
                    CustomPaint(painter: _SinePainter(_sine.value, accent)),
              ),
            ),
            const SizedBox(height: 18),
            // ── Morse-style status ───────────────────────────────────────
            AnimatedBuilder(
              animation: _blink,
              builder: (context, _) {
                final on = _blink.value < 0.5;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accent.withValues(alpha: on ? 1.0 : 0.16),
                      ),
                    ),
                    const SizedBox(width: 9),
                    Text(
                      widget.statusText,
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 3,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? const Color(0xFF64748B)
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 44),
          ],
        ),
      ),
    );
  }
}

/// A horizontally scrolling sine — the oscilloscope loading line.
class _SinePainter extends CustomPainter {
  _SinePainter(this.phase, this.color);

  final double phase;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const amp = 8.0;
    const period = 40.0;
    final mid = size.height / 2;

    final path = Path();
    for (double x = 0; x <= size.width; x += 2) {
      final y = mid +
          amp * math.sin((x / period) * 2 * math.pi + phase * 2 * math.pi);
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..color = color.withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(_SinePainter old) => old.phase != phase || old.color != color;
}
