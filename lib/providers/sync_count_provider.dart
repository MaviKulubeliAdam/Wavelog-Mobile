import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'remote_datasource_provider.dart';

/// Number of QSOs waiting to sync to the server.
/// Invalidated by QsoNotifier after every mutation so the drawer badge stays fresh.
final pendingSyncCountProvider = Provider<int>((ref) {
  final cache = ref.watch(qsoCacheDatasourceProvider);
  return cache.getUnsyncedCount();
});
