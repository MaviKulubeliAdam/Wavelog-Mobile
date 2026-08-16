import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'connectivity_provider.dart';
import 'qso_provider.dart';

/// Watches connectivity; when the device comes back online, triggers a QSO refresh.
final autoSyncProvider = Provider<void>((ref) {
  ref.listen<AsyncValue<List>>(connectivityProvider, (prev, next) {
    final wasOffline = prev?.valueOrNull?.every((r) =>
            r.toString().contains('none') || r.toString().contains('bluetooth')) ??
        false;
    final isOnline = ref.read(isOnlineProvider);
    if (wasOffline && isOnline) {
      ref.invalidate(qsoProvider);
    }
  });
});
