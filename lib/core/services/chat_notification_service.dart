import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../router.dart';

/// Takip edilen sohbet odalarından gelen FCM data mesajlarını yerel bildirime
/// çevirir. FCM 'notification' alanı kullanılmıyor — bu sayede kendi
/// mesajımızı gönderdiğimizde bildirim bastırılabiliyor ve dokununca
/// doğru odaya gidilebiliyor (data-only mesajlar her zaman uygulama
/// koduna uğrar, sistem otomatik göstermez).
class ChatNotificationService {
  ChatNotificationService._();

  static const _keyActiveStationCallsign = 'wl_active_station_callsign';
  static const _channelId = 'chat_messages';

  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(
      const InitializationSettings(android: androidInit),
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null) _navigateToRoom(payload);
      },
    );

    const channel = AndroidNotificationChannel(
      _channelId,
      'Sohbet Mesajları',
      description: 'Takip edilen sohbet odalarındaki yeni mesajlar',
      importance: Importance.high,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static void _navigateToRoom(String payload) {
    final parts = payload.split('|');
    if (parts.length < 2) return;
    appRouter.push('/community/chat/${parts[0]}', extra: parts[1]);
  }

  /// FirebaseMessaging.onMessage / onBackgroundMessage'dan çağrılır.
  static Future<void> handleData(Map<String, dynamic> data) async {
    if (data['screen'] != 'chat') return;

    final roomId = data['roomId'] as String?;
    final roomName = data['roomName'] as String?;
    final callsign = data['callsign'] as String?;
    if (roomId == null || callsign == null) return;

    final prefs = await SharedPreferences.getInstance();
    final myCallsign = prefs.getString(_keyActiveStationCallsign);
    if (myCallsign != null &&
        myCallsign.toUpperCase() == callsign.toUpperCase()) {
      return; // kendi mesajımız, bildirim gösterme
    }

    await initialize();
    await _plugin.show(
      roomId.hashCode,
      data['title'] as String? ?? callsign,
      data['body'] as String? ?? '',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'Sohbet Mesajları',
          channelDescription:
              'Takip edilen sohbet odalarındaki yeni mesajlar',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: '$roomId|${roomName ?? roomId}',
    );
  }

  /// SplashScreen'den çağrılır — uygulama kapalıyken bildirime dokunularak
  /// açıldıysa hedef odayı döndürür; yoksa null.
  static Future<({String roomId, String roomName})?> getLaunchRoom() async {
    await initialize();
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp != true) return null;
    final payload = details?.notificationResponse?.payload;
    if (payload == null) return null;
    final parts = payload.split('|');
    if (parts.length < 2) return null;
    return (roomId: parts[0], roomName: parts[1]);
  }
}
