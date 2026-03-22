import 'package:flutter/foundation.dart';

// Dev vs prod: set at build time via --dart-define=FLAVOR=dev (or prod).
class AppFlavor {
  AppFlavor._();

  static const String _devFlavor = 'dev';
  static const String _prodFlavor = 'prod';

  static bool get isDev {
    // ignore: do_not_use_environment
    const flavor = String.fromEnvironment(
      'FLAVOR',
      defaultValue: kReleaseMode ? _prodFlavor : _devFlavor,
    );
    return flavor == _devFlavor;
  }
}
