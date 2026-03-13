// Central config: reads BASE_URL, SOCKET_URL, Firebase, and dev credentials from
// dotenv (.env.dev / .env.prod). devInstance comes from platform: runtime env on
// desktop (env_config_io), fixed 1 on web (env_config_stub).
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'env_config_io.dart' if (dart.library.html) 'env_config_stub.dart' as dev_instance_lib;

class EnvConfig {
  static String get baseUrl {
    return dotenv.env['BASE_URL'] ?? 'http://localhost:3000/api';
  }

  static String get socketUrl {
    return dotenv.env['SOCKET_URL'] ?? 'ws://localhost:3000';
  }

  static String get firebaseApiKey {
    return dotenv.env['FIREBASE_API_KEY'] ?? '';
  }

  static String get firebaseAuthBaseUrl {
    return dotenv.env['FIREBASE_AUTH_BASE_URL'] ??
        'https://identitytoolkit.googleapis.com/v1/accounts';
  }

  static int get devInstance => dev_instance_lib.getDevInstance();

  static String get devUsername => _readDevCredential('DEV_USERNAME');

  static String get devPassword => _readDevCredential('DEV_PASSWORD');

  static String _readDevCredential(String keyPrefix) {
    final indexedKey = '${keyPrefix}_$devInstance';
    final indexedValue = dotenv.env[indexedKey];
    if (indexedValue != null && indexedValue.isNotEmpty) {
      return indexedValue;
    }
    return dotenv.env[keyPrefix] ?? '';
  }
}
