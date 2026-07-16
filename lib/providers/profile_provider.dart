import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasources/local/profile_local_datasource.dart';
import '../data/models/user_profile_model.dart';

final profileLocalDatasourceProvider =
    Provider<ProfileLocalDatasource>((ref) => ProfileLocalDatasource());

final profileProvider =
    AsyncNotifierProvider<ProfileNotifier, List<UserProfileModel>>(
        ProfileNotifier.new);

class ProfileNotifier extends AsyncNotifier<List<UserProfileModel>> {
  @override
  Future<List<UserProfileModel>> build() async {
    final ds = ref.read(profileLocalDatasourceProvider);
    return ds.getProfiles();
  }

  Future<void> addProfile(UserProfileModel profile) async {
    final ds = ref.read(profileLocalDatasourceProvider);
    await ds.addProfile(profile);
    state = await AsyncValue.guard(
        () => ref.read(profileLocalDatasourceProvider).getProfiles());
  }

  Future<void> updateProfile(UserProfileModel profile) async {
    final ds = ref.read(profileLocalDatasourceProvider);
    await ds.updateProfile(profile);
    state = await AsyncValue.guard(
        () => ref.read(profileLocalDatasourceProvider).getProfiles());
  }

  Future<void> deleteProfile(String id) async {
    final ds = ref.read(profileLocalDatasourceProvider);
    await ds.deleteProfile(id);
    state = await AsyncValue.guard(
        () => ref.read(profileLocalDatasourceProvider).getProfiles());
  }
}
