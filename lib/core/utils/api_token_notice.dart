import 'package:shared_preferences/shared_preferences.dart';

class ApiTokenNotice {
  ApiTokenNotice._();

  static const _keyDismissed = 'api_v2_token_notice_dismissed';

  static Future<bool> shouldShow() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_keyDismissed) ?? false);
  }

  static Future<void> markDismissed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDismissed, true);
  }
}
