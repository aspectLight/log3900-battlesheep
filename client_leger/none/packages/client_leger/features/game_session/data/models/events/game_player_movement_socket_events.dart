abstract class GamePlayerMovementSocketEvents {
  GamePlayerMovementSocketEvents._();

  static const String playerGetMovements = 'playerGetMovements';
  static const String playerGetMovementsResponse = 'playerGetMovementsResponse';
  static const String playerMoved = 'playerMoved';
  static const String playerTeleported = 'playerTeleported';
  static const String synchronizeMovement = 'synchronizeMovement';
  static const String virtualPlayerMoved = 'virtualPlayerMoved';
  static const String trapPending = 'trapPending';
  static const String trapChoice = 'trapChoice';
  static const String trapResult = 'trapResult';
  static const String torchIlluminationUpdate = 'torchIlluminationUpdate';
}
