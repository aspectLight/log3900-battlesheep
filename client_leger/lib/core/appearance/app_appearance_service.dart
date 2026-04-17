import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'app_visual_theme.dart';
import 'guest_locale_resolution.dart';

class AppAppearanceService {
  final Signal<AppVisualTheme> visualTheme = signal(
    AppVisualTheme.defaultTheme,
  );
  final Signal<Locale> locale = signal(resolveSupportedGuestLocale());

  /// True after the user picks a language on auth screens ([setLocaleLocally]).
  bool _guestChoseLanguage = false;

  void applyGuestDefaults() {
    _guestChoseLanguage = false;
    visualTheme.value = AppVisualTheme.defaultTheme;
    locale.value = resolveSupportedGuestLocale();
  }

  void applyFromServer({String? theme, String? language}) {
    _guestChoseLanguage = false;
    visualTheme.value = appVisualThemeFromId(theme);
    final lang = (language == 'en' || language == 'fr') ? language! : 'fr';
    locale.value = Locale(lang);
  }

  void setLocaleLocally(String languageCode) {
    locale.value = Locale(normalizeGuestLanguageCode(languageCode));
    _guestChoseLanguage = true;
  }

  /// When [serverLanguage] matches the guest choice, clears the guest flag.
  /// When they differ and the guest explicitly chose a language, returns the
  /// code to PATCH on the profile (caller should [clearGuestLanguageOverride]
  /// after handling the result).
  String? guestLanguageDisagreesWithServer(String serverLanguage) {
    if (!_guestChoseLanguage) return null;
    final code = normalizeGuestLanguageCode(locale.value.languageCode);
    final server = normalizeGuestLanguageCode(serverLanguage);
    if (code == server) {
      _guestChoseLanguage = false;
      return null;
    }
    return code;
  }

  void clearGuestLanguageOverride() {
    _guestChoseLanguage = false;
  }

  /// Re-reads the device locale after the first frame (dispatcher/OS may be
  /// wrong at [AppAppearanceService] construction time on some devices).
  void syncGuestLocaleFromPlatformIfNoExplicitChoice() {
    if (_guestChoseLanguage) return;
    locale.value = resolveSupportedGuestLocale();
  }

  /// Language for register / API when the user did not use the language
  /// control: always re-resolve from the platform so we do not send `fr`
  /// just because the in-memory signal was initialized too early.
  String effectiveLanguageCodeForApi() {
    if (_guestChoseLanguage) {
      return normalizeGuestLanguageCode(locale.value.languageCode);
    }
    return resolveSupportedGuestLocale().languageCode;
  }
}
