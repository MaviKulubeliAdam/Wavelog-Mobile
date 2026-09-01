import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/intent_handler.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../providers/settings_provider.dart';
import '../../../router.dart';
import '../celebration/api_v2_celebration_screen.dart';
import 'wave_splash.dart';

/// Splash screen — keeps the original routing logic, swaps the body
/// for the animated [WaveSplash] (logo signal-acquire + oscilloscope loader).
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    // Wait for settings to be loaded from SharedPreferences before routing.
    await ref.read(settingsProvider.notifier).whenLoaded;

    // Give the splash animation a moment so it doesn't flash by on fast loads.
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    final settings = ref.read(settingsProvider);

    if (settings.needsMigration) {
      context.go('/migration');
    } else if (!settings.hasValidConfig || !settings.isLoggedIn) {
      context.go('/setup-guide');
    } else {
      // Show one-time v3.2.0 patch-removal notice
      if (await ApiV2CelebrationScreen.shouldShow()) {
        if (!mounted) return;
        context.go('/v32-notice');
        return;
      }
      final pendingFile = await IntentHandler.getInitialFile();
      if (!mounted) return;
      context.go('/home');
      if (pendingFile != null) {
        await Future<void>.delayed(const Duration(milliseconds: 300));
        appRouter.push('/adif', extra: pendingFile);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaveSplash(statusText: context.l10n.splashConnecting),
    );
  }
}
