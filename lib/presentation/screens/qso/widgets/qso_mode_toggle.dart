import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Live/Historical QSO mode segmented toggle.
class QsoModeToggle extends StatelessWidget {
  final bool isLive;
  final String liveLabel;
  final String historicalLabel;
  final ValueChanged<bool> onChanged;

  const QsoModeToggle({
    super.key,
    required this.isLive,
    required this.liveLabel,
    required this.historicalLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: _ToggleBtn(
            label: liveLabel,
            icon: Icons.radio_button_checked,
            active: isLive,
            activeColor: Colors.green,
            onTap: () => onChanged(true),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ToggleBtn(
            label: historicalLabel,
            icon: Icons.history,
            active: !isLive,
            activeColor: cs.primary,
            onTap: () => onChanged(false),
          ),
        ),
      ],
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final Color activeColor;
  final VoidCallback onTap;

  const _ToggleBtn({
    required this.label,
    required this.icon,
    required this.active,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: active
              ? activeColor.withValues(alpha: 0.15)
              : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active
                ? activeColor.withValues(alpha: 0.7)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 16, color: active ? activeColor : cs.onSurfaceVariant),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                color: active ? activeColor : cs.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Live UTC clock tile ───────────────────────────────────────────────────────
// Kendi timer'ıyla tik atar — saati form state'inde tutmak tüm formu
// saniyede bir yeniden çiziyordu.

class QsoLiveClockTile extends StatefulWidget {
  final String label;

  const QsoLiveClockTile({super.key, required this.label});

  @override
  State<QsoLiveClockTile> createState() => _QsoLiveClockTileState();
}

class _QsoLiveClockTileState extends State<QsoLiveClockTile> {
  Timer? _timer;
  DateTime _now = DateTime.now().toUtc();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now().toUtc());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withValues(alpha: 0.4)),
      ),
      child: Row(children: [
        const Icon(Icons.circle, color: Colors.green, size: 10),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.label,
                style: TextStyle(fontSize: 11, color: cs.secondary)),
            Text(
              DateFormat('dd.MM.yyyy   HH:mm:ss').format(_now),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFeatures: [FontFeature.tabularFigures()]),
            ),
          ],
        ),
      ]),
    );
  }
}
