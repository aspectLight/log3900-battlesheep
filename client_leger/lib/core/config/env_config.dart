import 'package:flutter_dotenv/flutter_dotenv.dart';

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
}
