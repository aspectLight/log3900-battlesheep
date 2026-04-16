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

  static String resolveAvatarUrl(String rawAvatarUrl, {int? cacheBust}) {
    final trimmed = rawAvatarUrl.trim();
    if (trimmed.isEmpty) return '';
    final absolute =
        trimmed.startsWith('http://') || trimmed.startsWith('https://');
    final base = absolute ? trimmed : '$baseUrl$trimmed';
    if (cacheBust == null) return base;
    final separator = base.contains('?') ? '&' : '?';
    return '$base${separator}t=$cacheBust';
  }
}
