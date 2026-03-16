import 'dart:async';

import '../../domain/commands/game_movement_commands.dart';
import '../services/game_player_movement_socket.dart';

class GamePlayerMovementRepository {
  final GamePlayerMovementSocket _movementSocket;

  GamePlayerMovementRepository({
    required GamePlayerMovementSocket movementSocket,
  }) : _movementSocket = movementSocket;

  void getMovements(PlayerGetMovementsCommand command) {
    unawaited(_movementSocket.playerGetMovements(command));
  }

  void movePlayer(PlayerMovedCommand command) {
    _movementSocket.playerMoved(command);
  }

  void synchronizeMovement(SynchronizeMovementCommand command) {
    _movementSocket.synchronizeMovement(command);
  }

  void teleportPlayer(PlayerTeleportedCommand command) {
    _movementSocket.playerTeleported(command);
  }
}
