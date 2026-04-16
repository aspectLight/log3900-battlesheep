import '../enums/board_size.dart';
import '../typedefs/player_limits.dart';

class GameRulesConstants {
  static const int msToSeconds = 1000;
  static const int defaultNotificationDurationMs = 5000;
  static const int requiredCombatWins = 3;
  static const int inventorySlotCount = 2;
  static const int movementStepDelayMs = 150;
  static const int turnStartAutoForwardDelayMs = 3100;
  static const int actionPointsPerTurn = 1;

  static const Map<BoardSize, PlayerLimits> sizeLimits = {
    BoardSize.small: (min: 2, max: 2),
    BoardSize.medium: (min: 2, max: 4),
    BoardSize.large: (min: 2, max: 6),
  };
}
