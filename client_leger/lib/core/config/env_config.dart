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

    if (trimmed.startsWith('/') && baseOk) {
      // Uri.resolve against `http://host:3000/api` replaces the path with
      // `/auth/...`, dropping `/api`. The API lives under `/api/auth/avatar/...`.
      return _appendAvatarCacheBust(
        _joinApiBaseWithAbsolutePath(apiBaseUri, trimmed),
        cacheBust,
      );
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
    var path = incoming.path;
    final underApi = path.startsWith('/api/') || path == '/api';
    // Server stores `/auth/avatar/:uid`; global prefix is `api` → `/api/auth/avatar/...`.
    if (!underApi && path.startsWith('/auth/')) {
      path = '/api$path';
    }
    final underApiAfterFix = path.startsWith('/api/') || path == '/api';
    if (!localhostish && !underApiAfterFix) return incoming;

    return incoming.replace(
      scheme: apiBaseUri.scheme,
      host: apiBaseUri.host,
      port: apiBaseUri.port,
      path: path,
    );
  }

  /// Join the API base path (e.g. `/api`) with a path like `/auth/avatar/x?v=…`.
  static String _joinApiBaseWithAbsolutePath(Uri apiBaseUri, String pathAndQuery) {
    final ref = Uri.parse('http://_.invalid$pathAndQuery');
    final basePath = apiBaseUri.path;
    final normalized = basePath.endsWith('/') && basePath.isNotEmpty
        ? basePath.substring(0, basePath.length - 1)
        : basePath;
    final mergedPath = '$normalized${ref.path}';
    return apiBaseUri
        .replace(
          path: mergedPath,
          queryParameters: ref.hasQuery ? ref.queryParameters : null,
          fragment: ref.hasFragment ? ref.fragment : null,
        )
        .toString();
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
