import '../../features/game_session/core/enums/stat_type.dart';

class StatAssets {
  static const String path = 'assets/images/stats';
  static const String uiPath = 'assets/images/ui';

  static String statIconPath(StatType type) => switch (type) {
        StatType.health => '$path/stat_health.png',
        StatType.attack => '$path/stat_attack.png',
        StatType.defense => '$path/stat_defense.png',
        StatType.speed => '$path/stat_speed.png',
      };

  static const String diceD4 = '$uiPath/dice_d4.png';
  static const String diceD6 = '$uiPath/dice_d6.png';

  static String dicePath(StatType targetStat, StatType selectedStat) =>
      selectedStat == targetStat ? diceD6 : diceD4;
}
