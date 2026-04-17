import 'dart:ui';

import 'package:flutter/foundation.dart' show kIsWeb;

import 'guest_locale_resolution_stub.dart'
    if (dart.library.io) 'guest_locale_resolution_io.dart' as os_locale;

/// Must stay aligned with server profile enums and auth localizations.
const Set<String> supportedGuestLanguageCodes = {'en', 'fr'};

bool _isUndeterminedLanguageCode(String code) =>
    code.isEmpty || code == 'und';

/// Maps the platform locale to `en` or `fr` when supported; otherwise French.
///
/// Uses the full platform locale list from the dispatcher (not only the
/// primary locale's language code), and on IO falls back to the OS locale name
/// so we
/// still get `en` when the dispatcher briefly reports an undetermined code
/// before the first frame (common on some Android releases).
Locale resolveSupportedGuestLocale([Locale? platformLocale]) {
  if (platformLocale != null) {
    final c = platformLocale.languageCode.toLowerCase();
    if (!_isUndeterminedLanguageCode(c) &&
        supportedGuestLanguageCodes.contains(c)) {
      return Locale(c);
    }
  }

  for (final loc in PlatformDispatcher.instance.locales) {
    final c = loc.languageCode.toLowerCase();
    if (_isUndeterminedLanguageCode(c)) continue;
    if (supportedGuestLanguageCodes.contains(c)) return Locale(c);
  }

  final primary = PlatformDispatcher.instance.locale.languageCode.toLowerCase();
  if (!_isUndeterminedLanguageCode(primary) &&
      supportedGuestLanguageCodes.contains(primary)) {
    return Locale(primary);
  }

  if (!kIsWeb) {
    final raw = os_locale.platformLocaleNameFromOs();
    if (raw != null && raw.isNotEmpty) {
      final c = raw.split(RegExp('[-_]')).first.toLowerCase();
      if (supportedGuestLanguageCodes.contains(c)) return Locale(c);
    }
  }

  return const Locale('fr');
}

String normalizeGuestLanguageCode(String raw) {
  final c = raw.toLowerCase();
  if (supportedGuestLanguageCodes.contains(c)) return c;
  return 'fr';
}
