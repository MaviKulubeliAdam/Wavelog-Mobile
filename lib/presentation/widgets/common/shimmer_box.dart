import 'package:flutter/material.dart';

/// A theme-aware shimmer placeholder block. Use to build skeleton loaders
/// while data is being fetched.
///
/// ```dart
/// const ShimmerBox(width: 120, height: 14);          // text line
/// const ShimmerBox(width: 42, height: 42, shape: BoxShape.circle); // avatar
/// ```
class ShimmerBox extends StatefulWidget {
  const ShimmerBox({
    super.key,
    this.width,
    this.height = 14,
    this.radius = 6,
    this.shape = BoxShape.rectangle,
  });

  final double? width;
  final double height;
  final double radius;
  final BoxShape shape;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))
        ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? const Color(0xFF1A2536) : const Color(0xFFE2E8F0);
    final hi = isDark ? const Color(0xFF27374D) : const Color(0xFFF3F6FA);

    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = _c.value;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            shape: widget.shape,
            borderRadius: widget.shape == BoxShape.rectangle
                ? BorderRadius.circular(widget.radius)
                : null,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [base, hi, base],
              stops: [
                (t - 0.30).clamp(0.0, 1.0),
                t.clamp(0.0, 1.0),
                (t + 0.30).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
