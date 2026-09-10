import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasources/remote/callsign_claim_datasource.dart';
import 'auth_provider.dart';
import 'settings_provider.dart';

final callsignClaimDatasourceProvider =
    Provider<CallsignClaimDatasource>((_) => CallsignClaimDatasource());

/// State of the callsign claim for the current user.
enum ClaimState { idle, loading, verified, takenByOther, noCallsign, notSignedIn }

class CallsignClaimNotifier extends AsyncNotifier<ClaimState> {
  @override
  Future<ClaimState> build() async {
    final user = ref.watch(authStateProvider).valueOrNull;
    if (user == null) return ClaimState.notSignedIn;

    final callsign =
        ref.watch(settingsProvider).activeStationCallsign;
    if (callsign == null || callsign.isEmpty) return ClaimState.noCallsign;

    // Auto-claim on build (fires on every auth/settings change)
    return _attemptClaim(user.uid, callsign);
  }

  Future<ClaimState> _attemptClaim(String uid, String callsign) async {
    final result = await ref
        .read(callsignClaimDatasourceProvider)
        .claimCallsign(callsign, uid);
    switch (result) {
      case ClaimResult.claimed:
      case ClaimResult.alreadyOwned:
        return ClaimState.verified;
      case ClaimResult.takenByOther:
        return ClaimState.takenByOther;
    }
  }

  /// Trigger a manual re-attempt (e.g. after switching callsign).
  Future<void> reClaim() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}

final callsignClaimProvider =
    AsyncNotifierProvider<CallsignClaimNotifier, ClaimState>(
        CallsignClaimNotifier.new);
