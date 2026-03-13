import '../enums/stat_type.dart';

class CombatUiConstants {
  CombatUiConstants._();

  static const int feedbackDurationMs = 800;
  static const int animationDurationMs = 500;
  static const int notificationDurationMs = 3000;

  static const Map<StatType, String> diceChoiceLabels = {
    StatType.attack: 'A',
    StatType.defense: 'D',
  };
}
