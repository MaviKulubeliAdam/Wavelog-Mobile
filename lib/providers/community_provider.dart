import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasources/remote/community_datasource.dart';
import '../data/models/planned_activation_model.dart';

final communityDatasourceProvider = Provider<CommunityDatasource>(
  (_) => CommunityDatasource(),
);

final upcomingActivationsProvider =
    StreamProvider<List<PlannedActivationModel>>((ref) {
  return ref.watch(communityDatasourceProvider).watchUpcomingActivations();
});

// Kullanıcının abone olduğu aktivasyon ID'leri (local, session)
final subscribedActivationsProvider =
    StateProvider<Set<String>>((_) => {});

class CommunityNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> postActivation(PlannedActivationModel activation) async {
    final ds = ref.read(communityDatasourceProvider);
    final canPost = await ds.canPostActivation(activation.callsign);
    if (!canPost) return 'Son 5 dakika içinde duyuru yapıldı. Lütfen bekleyin.';
    await ds.addActivation(activation);
    return null; // null = başarılı
  }

  Future<void> toggleSubscribe(String activationId) async {
    final ds = ref.read(communityDatasourceProvider);
    final subscribed = ref.read(subscribedActivationsProvider);
    if (subscribed.contains(activationId)) {
      await ds.unsubscribeFromActivation(activationId);
      ref.read(subscribedActivationsProvider.notifier).update(
            (s) => {...s}..remove(activationId),
          );
    } else {
      await ds.subscribeToActivation(activationId);
      ref.read(subscribedActivationsProvider.notifier).update(
            (s) => {...s, activationId},
          );
    }
  }
}

final communityNotifierProvider =
    AsyncNotifierProvider<CommunityNotifier, void>(CommunityNotifier.new);
