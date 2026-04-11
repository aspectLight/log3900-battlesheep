import 'package:get_it/get_it.dart';

import '../../data/reducers/game_combat_state_reducer.dart';
import '../../data/repositories/game_actions_repository.dart';
import '../../data/repositories/game_combat_repository.dart';
import '../../data/repositories/game_debug_repository.dart';
import '../../data/repositories/game_item_repository.dart';
import '../../data/repositories/game_player_movement_repository.dart';
import '../../data/services/game_actions_socket.dart';
import '../../data/services/game_combat_socket.dart';
import '../../data/services/game_debug_socket.dart';
import '../../data/services/game_item_socket.dart';
import '../../data/services/game_player_movement_socket.dart';

void registerGameScopeRepositories(GetIt scope) {
  scope.registerLazySingleton<GameActionsRepository>(
    () => GameActionsRepository(
      actionsSocket: scope.get<GameActionsSocket>(),
    ),
  );
  scope.registerLazySingleton<GameCombatRepository>(
    () => GameCombatRepository(
      combatSocket: scope.get<GameCombatSocket>(),
      reducer: scope.get<GameCombatStateReducer>(),
    ),
  );
  scope.registerLazySingleton<GameItemRepository>(
    () => GameItemRepository(itemSocket: scope.get<GameItemSocket>()),
  );
  scope.registerLazySingleton<GamePlayerMovementRepository>(
    () => GamePlayerMovementRepository(
      movementSocket: scope.get<GamePlayerMovementSocket>(),
    ),
  );
  scope.registerLazySingleton<GameDebugRepository>(
    () => GameDebugRepository(debugSocket: scope.get<GameDebugSocket>()),
  );
}
