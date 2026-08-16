import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/utils/error_l10n.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/utils/video_encoder.dart';
import '../../../data/models/achievement_model.dart';
import '../../../providers/achievement_provider.dart';
import '../../../providers/settings_provider.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final inputAsync = ref.watch(achievementInputProvider);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.achievementsTitle)),
      body: inputAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(localizeError(context, e))),
        data: (input) {
          final unlocked =
              allAchievements.where((a) => a.isUnlocked(input)).length;
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _ProgressHeader(
                    unlocked: unlocked, total: allAchievements.length),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(12),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final achievement = allAchievements[i];
                      final isUnlocked = achievement.isUnlocked(input);
                      return _AchievementCard(
                        achievement: achievement,
                        input: input,
                        isUnlocked: isUnlocked,
                        callsign: settings.activeStationCallsign ??
                            'Wavelog Mobile',
                      );
                    },
                    childCount: allAchievements.length,
                  ),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.70,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          );
        },
      ),
    );
  }
}

// ── Progress header ────────────────────────────────────────────────────────────

class _ProgressHeader extends StatelessWidget {
  final int unlocked;
  final int total;
  const _ProgressHeader({required this.unlocked, required this.total});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$unlocked / $total',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              Text(context.l10n.achievementsTitle,
                  style: TextStyle(color: cs.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: total > 0 ? unlocked / total : 0,
              minHeight: 8,
              backgroundColor: cs.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Achievement card ───────────────────────────────────────────────────────────

class _AchievementCard extends StatelessWidget {
  final AchievementDef achievement;
  final AchievementInput input;
  final bool isUnlocked;
  final String callsign;

  const _AchievementCard({
    required this.achievement,
    required this.input,
    required this.isUnlocked,
    required this.callsign,
  });

  String _localTitle(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    if (locale == 'tr') return achievement.titleTr;
    if (locale == 'pl') return achievement.titlePl;
    return achievement.titleEn;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fraction = achievement.progressFraction(input);

    return Card(
      color: isUnlocked
          ? cs.primaryContainer.withValues(alpha: 0.9)
          : cs.surfaceContainerHighest.withValues(alpha: 0.5),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isUnlocked ? () => _showShareDialog(context) : null,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Badge animation
              isUnlocked
                  ? Lottie.asset(
                      'assets/animations/achievements/${achievement.id.name}.json',
                      width: 96,
                      height: 96,
                      repeat: false,
                      errorBuilder: (_, __, ___) => Text(achievement.emoji,
                          style: const TextStyle(fontSize: 48)),
                    )
                  : ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        cs.onSurface.withValues(alpha: 0.15),
                        BlendMode.srcIn,
                      ),
                      child: Lottie.asset(
                        'assets/animations/achievements/${achievement.id.name}.json',
                        width: 96,
                        height: 96,
                        repeat: false,
                        errorBuilder: (_, __, ___) => Text(achievement.emoji,
                            style: TextStyle(
                                fontSize: 48,
                                color: cs.onSurface.withValues(alpha: 0.2))),
                      ),
                    ),

              // Title
              Text(
                _localTitle(context),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isUnlocked
                          ? cs.onPrimaryContainer
                          : cs.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Progress
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: fraction,
                      minHeight: 4,
                      backgroundColor: cs.surfaceContainerHighest,
                      color: isUnlocked ? cs.primary : cs.outline,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isUnlocked
                        ? '✓ ${context.l10n.achievementUnlocked}'
                        : context.l10n.progressLabel(
                            achievement
                                .progress(input)
                                .clamp(0, achievement.target),
                            achievement.target),
                    style: TextStyle(
                        fontSize: 10,
                        color:
                            isUnlocked ? cs.primary : cs.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showShareDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SizedBox(
        height: MediaQuery.of(ctx).size.height * 0.88,
        child: _ShareSheet(
          achievement: achievement,
          callsign: callsign,
          locale: Localizations.localeOf(context).languageCode,
        ),
      ),
    );
  }
}

// ── Share sheet — renders GIF by stepping the badge animation ─────────────────

class _ShareSheet extends StatefulWidget {
  final AchievementDef achievement;
  final String callsign;
  final String locale;
  const _ShareSheet({
    required this.achievement,
    required this.callsign,
    required this.locale,
  });

  @override
  State<_ShareSheet> createState() => _ShareSheetState();
}

class _ShareSheetState extends State<_ShareSheet>
    with SingleTickerProviderStateMixin {
  final _repaintKey = GlobalKey();
  late final AnimationController _badgeCtrl;
  bool _sharing = false;
  String _statusLabel = '';

  String get _title {
    if (widget.locale == 'tr') return widget.achievement.titleTr;
    if (widget.locale == 'pl') return widget.achievement.titlePl;
    return widget.achievement.titleEn;
  }

  @override
  void initState() {
    super.initState();
    _badgeCtrl = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _badgeCtrl.dispose();
    super.dispose();
  }

  Future<void> _share() async {
    final l10n = context.l10n;
    setState(() {
      _sharing = true;
      _statusLabel = l10n.gifPreparing;
    });
    try {
      final file = await _renderAsVideo(l10n);
      if (!mounted) return;
      _badgeCtrl.reset();
      _badgeCtrl.forward();
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'video/mp4')],
        text:
            '${widget.achievement.emoji} $_title — ${widget.callsign} via Wavelog Mobile',
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  /// Waits until Flutter has actually painted the next frame.
  Future<void> _awaitNextPaint() {
    final c = Completer<void>();
    WidgetsBinding.instance.addPostFrameCallback((_) => c.complete());
    WidgetsBinding.instance.scheduleFrame();
    return c.future;
  }

  Future<File> _renderAsVideo(dynamic l10n) async {
    final boundary = _repaintKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (boundary == null) throw Exception('render boundary not found');

    const fps = 25;
    const totalFrames = 24;

    final tmpDir = await getTemporaryDirectory();
    final outputPath =
        '${tmpDir.path}/achievement_${widget.achievement.id.name}.mp4';

    bool encoderReady = false;

    for (int i = 0; i <= totalFrames; i++) {
      _badgeCtrl.value = i / totalFrames;
      await _awaitNextPaint();

      final uiImage = await boundary.toImage(pixelRatio: 2.0);
      final byteData =
          await uiImage.toByteData(format: ui.ImageByteFormat.rawRgba);
      if (byteData == null) continue;

      final rgba = byteData.buffer.asUint8List();

      if (!encoderReady) {
        await VideoEncoder.initEncoder(
          width: uiImage.width,
          height: uiImage.height,
          fps: fps,
          outputPath: outputPath,
        );
        encoderReady = true;
      }

      await VideoEncoder.addFrame(rgba);

      if (mounted) {
        setState(() => _statusLabel =
            l10n.gifCapturing(((i / totalFrames) * 100).round()));
      }
    }

    if (mounted) setState(() => _statusLabel = l10n.gifEncoding);
    await VideoEncoder.finalizeEncoder();

    return File(outputPath);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          children: [
            // Preview card (also used as capture source)
            Expanded(
              child: Center(
                child: RepaintBoundary(
                  key: _repaintKey,
                  child: _ShareCard(
                    achievement: widget.achievement,
                    callsign: widget.callsign,
                    title: _title,
                    locale: widget.locale,
                    badgeCtrl: _badgeCtrl,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _sharing ? null : _share,
                icon: _sharing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.videocam_outlined),
                label: Text(_sharing
                    ? _statusLabel
                    : context.l10n.shareAchievement),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Share card (9:16 Instagram Stories style) ─────────────────────────────────

class _ShareCard extends StatelessWidget {
  final AchievementDef achievement;
  final String callsign;
  final String title;
  final String locale;
  final AnimationController? badgeCtrl;

  const _ShareCard({
    required this.achievement,
    required this.callsign,
    required this.title,
    required this.locale,
    this.badgeCtrl,
  });

  String get _playStoreLabel {
    switch (locale) {
      case 'tr': return 'Google Play\'de ücretsiz indir';
      case 'pl': return 'Pobierz za darmo w Google Play';
      default:   return 'Download free on Google Play';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 9 / 16,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D0D1A), Color(0xFF1A1040), Color(0xFF0D0D1A)],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _WavePainter())),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Branding
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.radio, color: Color(0xFF7B6FC4), size: 18),
                      SizedBox(width: 6),
                      Text(
                        'WAVELOG MOBILE',
                        style: TextStyle(
                          color: Color(0xFF7B6FC4),
                          fontSize: 11,
                          letterSpacing: 3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Badge circle with controlled Lottie
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [Color(0xFF3A2A7A), Color(0xFF1A1040)],
                      ),
                      border:
                          Border.all(color: const Color(0xFF7B6FC4), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color(0xFF7B6FC4).withValues(alpha: 0.4),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Lottie.asset(
                        'assets/animations/achievements/${achievement.id.name}.json',
                        width: 90,
                        height: 90,
                        controller: badgeCtrl,
                        onLoaded: (composition) {
                          if (badgeCtrl != null) {
                            badgeCtrl!.duration = composition.duration;
                            badgeCtrl!.forward();
                          }
                        },
                        repeat: badgeCtrl == null,
                        errorBuilder: (_, __, ___) => Text(achievement.emoji,
                            style: const TextStyle(fontSize: 56)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // "ACHIEVEMENT UNLOCKED" chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFF7B6FC4).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color(0xFF7B6FC4)
                              .withValues(alpha: 0.5)),
                    ),
                    child: Text(
                      context.l10n.achievementUnlocked.toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFFBBAEE8),
                        fontSize: 10,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    achievement.localDesc(locale),
                    style: const TextStyle(
                        color: Color(0xFFAAAAAA), fontSize: 13),
                    textAlign: TextAlign.center,
                  ),

                  const Spacer(),

                  // Callsign + Play Store
                  Column(
                    children: [
                      const Text('73 DE',
                          style: TextStyle(
                              color: Color(0xFF7B6FC4),
                              fontSize: 11,
                              letterSpacing: 2)),
                      Text(
                        callsign,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.play_arrow_rounded,
                                color: Color(0xFF7B6FC4), size: 14),
                            const SizedBox(width: 5),
                            Text(
                              _playStoreLabel,
                              style: const TextStyle(
                                color: Color(0xFFBBAEE8),
                                fontSize: 10,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Background wave painter ────────────────────────────────────────────────────

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF7B6FC4).withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (var i = 0; i < 5; i++) {
      final path = Path();
      final yBase = size.height * (0.3 + i * 0.12);
      path.moveTo(0, yBase);
      for (var x = 0.0; x <= size.width; x += 2) {
        final y = yBase + sin((x / size.width) * 2 * pi * 3 + i) * 12;
        path.lineTo(x, y);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_WavePainter _) => false;
}
