import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/appearance/app_appearance_service.dart';
import '../../../../../core/di/injection_container.dart';

class LanguagePickerButton extends StatelessWidget {
  const LanguagePickerButton({super.key});

  static const _languages = [('fr', '🇫🇷 Français'), ('en', '🇬🇧 English')];

  @override
  Widget build(BuildContext context) {
    final appearance = getIt<AppAppearanceService>();
    return Watch((context) {
      final current = appearance.locale.value.languageCode;
      return PopupMenuButton<String>(
        initialValue: current,
        onSelected: appearance.setLocaleLocally,
        itemBuilder: (_) => _languages
            .map(
              (l) => PopupMenuItem(
                value: l.$1,
                child: Text(
                  l.$2,
                  style: const TextStyle(fontFamily: 'CustomFont'),
                ),
              ),
            )
            .toList(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language, color: Colors.white, size: 20),
            const SizedBox(width: 6),
            Text(
              _languages.firstWhere((l) => l.$1 == current).$2,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'CustomFont',
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    });
  }
}
