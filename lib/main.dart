import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'core/services/intent_handler.dart';
import 'data/models/qso_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
