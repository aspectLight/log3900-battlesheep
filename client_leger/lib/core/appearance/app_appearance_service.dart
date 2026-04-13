import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'app_visual_theme.dart';

class AppAppearanceService {
  final Signal<AppVisualTheme> visualTheme = signal(
    AppVisualTheme.defaultTheme,
  );
  final Signal<Locale> locale = signal(const Locale('fr'));

  void applyGuestDefaults() {
    visualTheme.value = AppVisualTheme.defaultTheme;
    locale.value = const Locale('fr');
  }

  void applyFromServer({String? theme, String? language}) {
    visualTheme.value = appVisualThemeFromId(theme);
    final lang = (language == 'en' || language == 'fr') ? language! : 'fr';
    locale.value = Locale(lang);
  }

  void setLocaleLocally(String languageCode) {
    locale.value = Locale(languageCode);
  }
}
