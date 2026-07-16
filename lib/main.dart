import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'data/models/qso_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(QsoModelAdapter());
  await Hive.openBox<QsoModel>('qso_cache');

  runApp(
    const ProviderScope(
      child: WavelogMobileApp(),
    ),
  );
}
