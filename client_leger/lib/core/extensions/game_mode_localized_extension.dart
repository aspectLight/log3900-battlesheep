import 'package:flutter/widgets.dart';

import '../enums/game_mode.dart';
import '../localisation/core_localizations.dart';

extension GameModeLocalizedExtension on GameMode {
  String toLocalizedLabel(BuildContext context) {
    final l10n = CoreLocalizations.of(context)!;
    switch (this) {
      case GameMode.classic:
        return l10n.createGameModeClassic;
      case GameMode.captureTheFlag:
        return l10n.createGameModeCtf;
    }
  }
}

