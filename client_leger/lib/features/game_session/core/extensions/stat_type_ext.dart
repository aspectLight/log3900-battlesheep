import '../localisation/game_session_localizations.dart';
import '../enums/stat_type.dart';

extension StatTypeExtension on StatType {
  String resolveStatLabel(GameSessionLocalizations l10n) => switch (this) {
    StatType.health => l10n.statHealth,
    StatType.attack => l10n.statAttack,
    StatType.defense => l10n.statDefense,
    StatType.speed => l10n.statSpeed,
  };
}
