import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_profile_model.dart';

class ProfileLocalDatasource {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  static const _keyProfiles = 'wl_user_profiles';

  Future<List<UserProfileModel>> getProfiles() async {
    // Try secure storage first
    final secure = await _storage.read(key: _keyProfiles);
    if (secure != null) {
      final list = (jsonDecode(secure) as List<dynamic>).cast<String>();
      return list.map(UserProfileModel.fromJsonString).toList();
    }

    // One-time migration from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final legacy = prefs.getStringList(_keyProfiles) ?? [];
    if (legacy.isNotEmpty) {
      await _storage.write(key: _keyProfiles, value: jsonEncode(legacy));
      await prefs.remove(_keyProfiles);
    }
    return legacy.map(UserProfileModel.fromJsonString).toList();
  }

  Future<void> _saveAll(List<UserProfileModel> profiles) async {
    await _storage.write(
      key: _keyProfiles,
      value: jsonEncode(profiles.map((p) => p.toJsonString()).toList()),
    );
  }

  Future<void> addProfile(UserProfileModel profile) async {
    final profiles = await getProfiles();
    profiles.add(profile);
    await _saveAll(profiles);
  }

  Future<void> updateProfile(UserProfileModel profile) async {
    final profiles = await getProfiles();
    final idx = profiles.indexWhere((p) => p.id == profile.id);
    if (idx != -1) {
      profiles[idx] = profile;
      await _saveAll(profiles);
    }
  }

  Future<void> deleteProfile(String id) async {
    final profiles = await getProfiles();
    profiles.removeWhere((p) => p.id == id);
    await _saveAll(profiles);
  }
}
