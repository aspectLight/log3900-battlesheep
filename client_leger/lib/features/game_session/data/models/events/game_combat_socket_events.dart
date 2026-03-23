abstract class GameCombatSocketEvents {
  GameCombatSocketEvents._();

  static const String startCombat = 'startCombat';
  static const String startVirtualCombat = 'startVirtualCombat';
  static const String attack = 'attack';
  static const String flightAttempt = 'flightAttempt';
  static const String attackResult = 'attackResult';
  static const String flightAttemptResult = 'flightAttemptResult';
  static const String combatTurnStarted = 'combatTurnStarted';
  static const String updateCombatCountDown = 'updateCombatCountDown';
  static const String endCombat = 'endCombat';
}
