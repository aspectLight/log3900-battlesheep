import 'package:get_it/get_it.dart';

import '../../data/projections/game_board_events_projection.dart';
import '../../data/projections/game_combat_events_projection.dart';
import '../../data/projections/game_debug_events_projection.dart';
import '../../data/projections/game_item_events_projection.dart';
import '../../data/projections/game_movement_events_projection.dart';
import '../../data/projections/game_player_events_projection.dart';
import '../../data/projections/game_session_events_projection.dart';
import '../../data/projections/game_spawn_events_projection.dart';
import '../../data/projections/game_turn_events_projection.dart';
import '../../data/repositories/game_board_repository.dart';
import '../../data/repositories/game_combat_repository.dart';
import '../../data/repositories/game_debug_repository.dart';
import '../../data/repositories/game_inventory_repository.dart';
import '../../data/repositories/game_item_repository.dart';
import '../../data/repositories/game_metadata_repository.dart';
import '../../data/repositories/game_player_movement_repository.dart';
import '../../data/repositories/game_player_repository.dart';
import '../../data/repositories/game_turn_repository.dart';
import '../../data/services/game_board_socket.dart';
import '../../data/services/game_combat_socket.dart';
import '../../data/services/game_debug_socket.dart';
import '../../data/services/game_events_socket.dart';
import '../../data/services/game_item_socket.dart';
import '../../data/services/game_player_movement_socket.dart';
import '../event_bus/game_session_event_bus.dart';
import '../../../../core/notification/notification_coordinator.dart';

void registerGameProjections(
  GetIt scope,
  GetIt rootGetIt, {
  required String socketId,
  required String roomId,
}) {
  scope.registerLazySingleton<GameTurnEventsProjection>(
    () => GameTurnEventsProjection(
      eventsSocket: scope.get<GameEventsSocket>(),
      turnRepository: scope.get<GameTurnRepository>(),
      playerRepository: scope.get<GamePlayerRepository>(),
      gameSessionEventBus: rootGetIt.get<GameSessionEventBus>(),
    ),
  );
  scope.registerLazySingleton<GameSpawnEventsProjection>(
    () => GameSpawnEventsProjection(
      eventsSocket: scope.get<GameEventsSocket>(),
      playerRepository: scope.get<GamePlayerRepository>(),
      boardRepository: scope.get<GameBoardRepository>(),
      inventoryRepository: scope.get<GameInventoryRepository>(),
    ),
  );
  scope.registerLazySingleton<GameSessionEventsProjection>(
    () => GameSessionEventsProjection(
      eventsSocket: scope.get<GameEventsSocket>(),
      sessionRepository: scope.get<GameMetadataRepository>(),
      gameSessionEventBus: rootGetIt.get<GameSessionEventBus>(),
    ),
  );
  scope.registerLazySingleton<GamePlayerEventsProjection>(
    () => GamePlayerEventsProjection(
      eventsSocket: scope.get<GameEventsSocket>(),
      playerRepository: scope.get<GamePlayerRepository>(),
      gameSessionEventBus: rootGetIt.get<GameSessionEventBus>(),
    ),
  );
  scope.registerLazySingleton<GameBoardEventsProjection>(
    () => GameBoardEventsProjection(
      boardSocket: scope.get<GameBoardSocket>(),
      boardRepository: scope.get<GameBoardRepository>(),
      gameSessionEventBus: rootGetIt.get<GameSessionEventBus>(),
    ),
  );
  scope.registerLazySingleton<GameMovementEventsProjection>(
    () => GameMovementEventsProjection(
      movementSocket: scope.get<GamePlayerMovementSocket>(),
      boardRepository: scope.get<GameBoardRepository>(),
      playerRepository: scope.get<GamePlayerRepository>(),
      turnRepository: scope.get<GameTurnRepository>(),
      metadataRepository: scope.get<GameMetadataRepository>(),
      gameSessionEventBus: rootGetIt.get<GameSessionEventBus>(),
    ),
  );
  scope.registerLazySingleton<GameCombatEventsProjection>(
    () => GameCombatEventsProjection(
      combatSocket: scope.get<GameCombatSocket>(),
      combatRepository: scope.get<GameCombatRepository>(),
      gameSessionEventBus: rootGetIt.get<GameSessionEventBus>(),
      socketId: socketId,
    ),
  );
  scope.registerLazySingleton<GameItemEventsProjection>(
    () => GameItemEventsProjection(
      itemSocket: scope.get<GameItemSocket>(),
      boardRepository: scope.get<GameBoardRepository>(),
      inventoryRepository: scope.get<GameInventoryRepository>(),
      playerRepository: scope.get<GamePlayerRepository>(),
      gameSessionEventBus: rootGetIt.get<GameSessionEventBus>(),
      roomId: roomId,
      socketId: socketId,
      notificationCoordinator: rootGetIt.get<NotificationCoordinator>(),
      itemRepository: scope.get<GameItemRepository>(),
      movementRepository: scope.get<GamePlayerMovementRepository>(),
      turnRepository: scope.get<GameTurnRepository>(),
    ),
  );
  scope.registerLazySingleton<GameDebugEventsProjection>(
    () => GameDebugEventsProjection(
      debugSocket: scope.get<GameDebugSocket>(),
      debugRepository: scope.get<GameDebugRepository>(),
      gameSessionEventBus: rootGetIt.get<GameSessionEventBus>(),
    ),
  );
}
