import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/datasources/remote/community_datasource.dart';
import '../data/models/planned_activation_model.dart';

final communityDatasourceProvider = Provider<CommunityDatasource>(
  (_) => CommunityDatasource(),
);

final upcomingActivationsProvider =
    StreamProvider<List<PlannedActivationModel>>((ref) {
  return ref.watch(communityDatasourceProvider).watchUpcomingActivations();
});

// ─── Kalıcı abonelik listesi ─────────────────────────────────────────────────

class SubscribedActivationsNotifier extends AsyncNotifier<Set<String>> {
  static const _key = 'wl_subscribed_activations';

  @override
  Future<Set<String>> build() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_key) ?? []).toSet();
  }

  Future<void> _save(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, ids.toList());
  }

  Future<void> add(String id) async {
    final current = state.valueOrNull ?? {};
    final updated = {...current, id};
    state = AsyncValue.data(updated);
    await _save(updated);
  }

  Future<void> remove(String id) async {
    final current = state.valueOrNull ?? {};
    final updated = {...current}..remove(id);
    state = AsyncValue.data(updated);
    await _save(updated);
  }

  bool contains(String id) => state.valueOrNull?.contains(id) ?? false;
}

final subscribedActivationsProvider =
    AsyncNotifierProvider<SubscribedActivationsNotifier, Set<String>>(
        SubscribedActivationsNotifier.new);

// ─── Community notifier ──────────────────────────────────────────────────────

class CommunityNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> postActivation(PlannedActivationModel activation) async {
    final ds = ref.read(communityDatasourceProvider);
    final canPost = await ds.canPostActivation(activation.callsign);
    if (!canPost) return 'Son 5 dakika içinde duyuru yapıldı. Lütfen bekleyin.';
    await ds.addActivation(activation);
    return null;
  }

  Future<void> toggleSubscribe(String activationId) async {
    final ds = ref.read(communityDatasourceProvider);
    final notifier = ref.read(subscribedActivationsProvider.notifier);

    if (notifier.contains(activationId)) {
      await ds.unsubscribeFromActivation(activationId);
      await notifier.remove(activationId);
    } else {
      await ds.subscribeToActivation(activationId);
      await notifier.add(activationId);
    }
  }
}

final communityNotifierProvider =
    AsyncNotifierProvider<CommunityNotifier, void>(CommunityNotifier.new);
