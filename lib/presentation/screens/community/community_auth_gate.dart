import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/callsign_claim_provider.dart';

/// Wraps community content with Google sign-in + callsign verification.
/// Shows child only when the user is signed in and their callsign is verified.
class CommunityAuthGate extends ConsumerWidget {
  final Widget child;
  const CommunityAuthGate({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final claimAsync = ref.watch(callsignClaimProvider);

    return claimAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorView(message: '$e'),
      data: (state) {
        switch (state) {
          case ClaimState.verified:
            return child;

          case ClaimState.notSignedIn:
            return _SignInView();

          case ClaimState.noCallsign:
            return _InfoView(
              icon: Icons.radio_outlined,
              title: context.l10n.chatNoStation,
              subtitle: context.l10n.communitySignInNoStation,
            );

          case ClaimState.takenByOther:
            return _TakenView();

          case ClaimState.loading:
          case ClaimState.idle:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

// ── Sign-in screen ────────────────────────────────────────────────────────────

class _SignInView extends ConsumerStatefulWidget {
  @override
  ConsumerState<_SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends ConsumerState<_SignInView> {
  bool _loading = false;
  String? _error;

  Future<void> _signIn() async {
    setState(() { _loading = true; _error = null; });
    final result = await ref
        .read(authNotifierProvider.notifier)
        .signInWithGoogle();
    if (mounted) {
      setState(() {
        _loading = false;
        _error = result.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified_user_outlined, size: 64, color: cs.primary),
            const SizedBox(height: 20),
            Text(
              context.l10n.communitySignInTitle,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.communitySignInSubtitle,
              style: TextStyle(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: TextStyle(color: cs.error, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 32),
            FilledButton.icon(
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const _GoogleLogo(),
              label: Text(context.l10n.communitySignInButton),
              onPressed: _loading ? null : _signIn,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Callsign taken screen ─────────────────────────────────────────────────────

class _TakenView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.gpp_bad_outlined, size: 64, color: cs.error),
            const SizedBox(height: 20),
            Text(
              context.l10n.communityCallsignTaken,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: cs.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              icon: const Icon(Icons.logout),
              label: Text(context.l10n.communitySignOut),
              onPressed: () =>
                  ref.read(authNotifierProvider.notifier).signOut(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Generic info screen ───────────────────────────────────────────────────────

class _InfoView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _InfoView(
      {required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(subtitle,
                style: const TextStyle(color: Colors.grey),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// ── Google "G" logo (drawn, no image needed) ──────────────────────────────────

class _GoogleLogo extends StatelessWidget {
  const _GoogleLogo();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 18,
      height: 18,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  const _GooglePainter();

  @override
  void paint(Canvas canvas, Size size) {
    const segments = [
      (Color(0xFF4285F4), 0.0, 1.0),   // blue  right arc
      (Color(0xFFEA4335), 1.0, 1.75),  // red   top
      (Color(0xFFFBBC05), 1.75, 2.5),  // yellow bottom-left
      (Color(0xFF34A853), 2.5, 3.0),   // green bottom-right
    ];
    final r = size.width / 2;
    final center = Offset(r, r);
    for (final (color, start, end) in segments) {
      final paint = Paint()
        ..color = color
        ..strokeWidth = size.width * 0.28
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r * 0.72),
        start * 3.14159,
        (end - start) * 3.14159,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
