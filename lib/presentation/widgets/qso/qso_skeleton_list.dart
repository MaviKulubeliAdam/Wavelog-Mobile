import 'package:flutter/material.dart';
import '../common/shimmer_box.dart';

/// Skeleton placeholder for the home / logbook QSO list shown on first load,
/// before the recent QSOs arrive. Mirrors the real card layout (avatar +
/// two text lines) so the swap to real data is visually stable.
///
/// ```dart
/// // while loading:
/// const QsoSkeletonList(count: 6)
/// ```
class QsoSkeletonList extends StatelessWidget {
  const QsoSkeletonList({super.key, this.count = 6});

  final int count;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF131D2E) : Colors.white;
    final cardBorder = isDark ? const Color(0xFF1A2740) : const Color(0xFFE2E8F0);

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: count,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final titleW = 110.0 + (i % 3) * 26;
        final subW = 150.0 + (i % 2) * 30;
        return Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cardBorder),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const ShimmerBox(width: 42, height: 42, shape: BoxShape.circle),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(width: titleW, height: 13),
                    const SizedBox(height: 9),
                    ShimmerBox(width: subW, height: 10),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
