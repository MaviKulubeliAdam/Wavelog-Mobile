import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/station_logbook_model.dart';
import 'remote_datasource_provider.dart';
import 'settings_provider.dart';

final stationLogbookProvider =
    AsyncNotifierProvider<StationLogbookNotifier, List<StationLogbookModel>>(
        StationLogbookNotifier.new);

class StationLogbookNotifier
    extends AsyncNotifier<List<StationLogbookModel>> {
  @override
  Future<List<StationLogbookModel>> build() => _fetch();

  Future<List<StationLogbookModel>> _fetch() {
    return ref.read(stationLogbookRepositoryProvider).getLogbooks();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<String?> createLogbook(String name) async {
    try {
      await ref.read(stationLogbookRepositoryProvider).createLogbook(name);
      await refresh();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updateLogbook(int logbookId, String name) async {
    try {
      await ref
          .read(stationLogbookRepositoryProvider)
          .updateLogbook(logbookId, name);
      await refresh();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> deleteLogbook(int logbookId) async {
    try {
      await ref
          .read(stationLogbookRepositoryProvider)
          .deleteLogbook(logbookId);
      await refresh();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> setActive(int logbookId) async {
    try {
      await ref
          .read(stationLogbookRepositoryProvider)
          .setActiveLogbook(logbookId);
      await ref.read(settingsProvider.notifier).setActiveLogbook(logbookId);
      // Keep the cached list's `active` flag in step (no loading flash), since
      // the QSO scope follows it.
      final current = state.valueOrNull;
      if (current != null) {
        state = AsyncData([
          for (final l in current) l.copyWith(active: l.id == logbookId),
        ]);
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> link(int logbookId, int stationId) async {
    try {
      await ref
          .read(stationLogbookRepositoryProvider)
          .link(logbookId, stationId);
      await refresh();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> unlink(int logbookId, int stationId) async {
    try {
      await ref
          .read(stationLogbookRepositoryProvider)
          .unlink(logbookId, stationId);
      await refresh();
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
