abstract class GameEventsSocketEvents {
  GameEventsSocketEvents._();

  static const String playerSpawned = 'playerSpawned';
  static const String turnStarting = 'turnStarting';
  static const String updateCountdown = 'updateCountdown';
  static const String updateStartingCountdown = 'updateStartingCountdown';
  static const String updateScore = 'updateScore';
  static const String finishGame = 'finishGame';
  static const String gameCanceled = 'gameCanceled';
  static const String gameAbandoned = 'gameAbandoned';
  static const String playerAbandoned = 'playerAbandoned';
  static const String organizatorChanged = 'organizatorChanged';
  static const String playGame = 'playGame';
}
