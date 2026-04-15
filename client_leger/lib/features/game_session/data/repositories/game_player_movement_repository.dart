import 'dart:async';

import '../../domain/commands/game_movement_commands.dart';
import '../../domain/events/game_environment_events.dart';
import '../../domain/events/game_movement_events.dart';
import '../services/game_player_movement_socket.dart';

class GamePlayerMovementRepository {
  final GamePlayerMovementSocket _movementSocket;

  GamePlayerMovementRepository({
    required GamePlayerMovementSocket movementSocket,
  }) : _movementSocket = movementSocket;

  Stream<ReachablePathsResponseEvent> get reachablePathsResponseStream =>
      _movementSocket.reachablePathsResponseStream;

  Stream<TrapPendingEvent> get trapPendingStream =>
      _movementSocket.trapPendingStream;

  Stream<TrapResultSyncEvent> get trapResultStream =>
      _movementSocket.trapResultStream;

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

  void trapChoice(TrapChoiceCommand command) {
    _movementSocket.trapChoice(command);
  }
}
