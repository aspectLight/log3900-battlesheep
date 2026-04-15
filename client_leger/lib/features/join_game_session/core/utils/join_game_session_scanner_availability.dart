import 'package:flutter/foundation.dart';

class JoinGameSessionScannerAvailability {
  JoinGameSessionScannerAvailability._();

  static bool get isSupported {
    if (kIsWeb) {
      return false;
    }
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }
}
