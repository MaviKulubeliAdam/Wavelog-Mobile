import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'remote_datasource_provider.dart';

/// Maps server QSO id → confirmed-via types (e.g. ["LoTW", "eQSL"]).
/// Returns an empty map on any error (token may not have confirmation:read scope).
final confirmationProvider =
    FutureProvider<Map<int, List<String>>>((ref) async {
  try {
    final ds = ref.watch(wavelogRemoteDatasourceProvider);
    return await ds.getConfirmations();
  } catch (_) {
    return {};
  }
});
