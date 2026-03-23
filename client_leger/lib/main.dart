import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app_root.dart';
import 'core/config/app_flavor.dart';
import 'core/di/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final envFileName = AppFlavor.isDev ? '.env.dev' : '.env.prod';
  try {
    await dotenv.load(fileName: envFileName);
  } on Object {
    debugPrint('Warning: $envFileName not found, using defaults.');
  }

  await setupDependencies();

  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    const windowSize = Size(1280, 768);
    await windowManager.setTitle('Client Léger');
    await windowManager.setSize(windowSize);
    await windowManager.setMinimumSize(windowSize);
    await windowManager.center();
  }

  runApp(const AppRoot());
}
