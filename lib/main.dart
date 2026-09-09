import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'core/services/intent_handler.dart';
import 'data/models/qso_model.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Android 13+ bildirim izni (iOS için de gerekli)
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // Genel aktivasyon feed'ine abone ol
  await FirebaseMessaging.instance.subscribeToTopic('new_activations');

  await Hive.initFlutter();
  Hive.registerAdapter(QsoModelAdapter());
  await Hive.openBox<QsoModel>('qso_cache');

  IntentHandler.initialize();

  runApp(
    const ProviderScope(
      child: WavelogMobileApp(),
    ),
  );
}
