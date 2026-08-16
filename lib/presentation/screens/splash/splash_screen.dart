import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../providers/settings_provider.dart';
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
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaveSplash(statusText: context.l10n.splashConnecting),
    );
  }
}
