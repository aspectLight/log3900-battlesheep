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
    if (trimmed.startsWith('data:')) return trimmed;

    final apiBaseUri = Uri.tryParse(baseUrl);
    final baseOk = apiBaseUri != null &&
        apiBaseUri.hasScheme &&
        apiBaseUri.host.isNotEmpty;

    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      final incoming = Uri.tryParse(trimmed);
      if (incoming != null &&
          incoming.hasScheme &&
          incoming.host.isNotEmpty &&
          baseOk) {
        final resolved = _rebaseAbsoluteAvatarToConfiguredApiIfNeeded(
          incoming,
          apiBaseUri,
        );
        return _appendAvatarCacheBust(resolved.toString(), cacheBust);
      }
      return _appendAvatarCacheBust(trimmed, cacheBust);
    }

    final base = baseOk ? '$baseUrl$trimmed' : trimmed;
    return _appendAvatarCacheBust(base, cacheBust);
  }

  /// Web clients often send `http://localhost:3000/api/...`, which is not
  /// reachable from a device/emulator. Rewrite host/scheme/port to [baseUrl].
  static Uri _rebaseAbsoluteAvatarToConfiguredApiIfNeeded(
    Uri incoming,
    Uri apiBaseUri,
  ) {
    final host = incoming.host.toLowerCase();
    final localhostish = host == 'localhost' ||
        host == '127.0.0.1' ||
        host == '0.0.0.0' ||
        host == '::1';
    final path = incoming.path;
    final underApi = path.startsWith('/api/') || path == '/api';
    if (!localhostish && !underApi) return incoming;

    return incoming.replace(
      scheme: apiBaseUri.scheme,
      host: apiBaseUri.host,
      port: apiBaseUri.port,
    );
  }

  static String _appendAvatarCacheBust(String base, int? cacheBust) {
    if (cacheBust == null) return base;
    final separator = base.contains('?') ? '&' : '?';
    return '$base${separator}t=$cacheBust';
  }

  /// Angular chat attaches `${environment.serverUrl}${profile.avatarUrl}` on send.
  static String? absoluteProfileAvatarUrlForChatSocket(String? relativeOrAbsolute) {
    final t = relativeOrAbsolute?.trim();
    if (t == null || t.isEmpty) return null;
    final full = resolveAvatarUrl(t);
    return full.isEmpty ? null : full;
  }
}
