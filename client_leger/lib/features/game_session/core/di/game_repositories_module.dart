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

void registerGameRepositories(GetIt getIt) {
  getIt.registerLazySingleton<GameActionsRepository>(
    () => GameActionsRepository(
      actionsSocket: getIt<GameActionsSocket>(),
    ),
  );
  getIt.registerLazySingleton<GameCombatRepository>(
    () => GameCombatRepository(
      combatSocket: getIt<GameCombatSocket>(),
      reducer: getIt<GameCombatStateReducer>(),
    ),
  );
  getIt.registerLazySingleton<GameItemRepository>(
    () => GameItemRepository(itemSocket: getIt<GameItemSocket>()),
  );
  getIt.registerLazySingleton<GamePlayerMovementRepository>(
    () => GamePlayerMovementRepository(
      movementSocket: getIt<GamePlayerMovementSocket>(),
    ),
  );
  getIt.registerLazySingleton<GameDebugRepository>(
    () => GameDebugRepository(debugSocket: getIt<GameDebugSocket>()),
  );
}
