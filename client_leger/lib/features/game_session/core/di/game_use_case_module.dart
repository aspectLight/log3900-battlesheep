import 'package:get_it/get_it.dart';

import '../../data/repositories/game_actions_repository.dart';
import '../../data/repositories/game_board_interaction_repository.dart';
import '../../data/repositories/game_board_repository.dart';
import '../../data/repositories/game_combat_repository.dart';
import '../../data/repositories/game_debug_repository.dart';
import '../../data/repositories/game_player_movement_repository.dart';
import '../../data/repositories/game_inventory_repository.dart';
import '../../data/repositories/game_player_repository.dart';
import '../../data/repositories/game_turn_repository.dart';
import '../../domain/use_cases/debug_teleport_player_use_case.dart';
import '../../domain/use_cases/execute_board_action_use_case.dart';
import '../../domain/use_cases/forward_turn_use_case.dart';
import '../../domain/use_cases/move_player_use_case.dart';

void registerGameUseCases(
  GetIt scope,
  GetIt rootGetIt, {
  required String roomId,
  required String socketId,
}) {
  scope.registerFactory<ForwardTurnUseCase>(
    () => ForwardTurnUseCase(
      roomId: roomId,
      turnRepository: scope.get<GameTurnRepository>(),
      actionsRepository: scope.get<GameActionsRepository>(),
    ),
  );
  scope.registerFactory<ExecuteBoardActionUseCase>(
    () => ExecuteBoardActionUseCase(
      roomId: roomId,
      socketId: socketId,
      boardRepository: scope.get<GameBoardRepository>(),
      combatRepository: scope.get<GameCombatRepository>(),
      interactionRepository: scope.get<GameBoardInteractionRepository>(),
      playerRepository: scope.get<GamePlayerRepository>(),
      movementRepository: scope.get<GamePlayerMovementRepository>(),
      inventoryRepository: scope.get<GameInventoryRepository>(),
    ),
  );
  scope.registerFactory<MovePlayerUseCase>(
    () => MovePlayerUseCase(
      roomId: roomId,
      turnRepository: scope.get<GameTurnRepository>(),
      boardRepository: scope.get<GameBoardRepository>(),
      movementRepository: scope.get<GamePlayerMovementRepository>(),
    ),
  );
  scope.registerFactory<DebugTeleportPlayerUseCase>(
    () => DebugTeleportPlayerUseCase(
      roomId: roomId,
      socketId: socketId,
      debugRepository: scope.get<GameDebugRepository>(),
      turnRepository: scope.get<GameTurnRepository>(),
      boardRepository: scope.get<GameBoardRepository>(),
      movementRepository: scope.get<GamePlayerMovementRepository>(),
    ),
  );
}
