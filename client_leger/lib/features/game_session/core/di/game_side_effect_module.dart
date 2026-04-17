import 'package:get_it/get_it.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/notification/notification_coordinator.dart';
import '../../../../core/notification/notification_intent_sink.dart';
import '../../data/repositories/game_actions_repository.dart';
import '../../data/repositories/game_board_interaction_repository.dart';
import '../../data/repositories/game_board_repository.dart';
import '../../data/repositories/game_combat_repository.dart';
import '../../data/repositories/game_debug_repository.dart';
import '../../data/repositories/game_inventory_repository.dart';
import '../../data/repositories/game_item_repository.dart';
import '../../data/repositories/game_metadata_repository.dart';
import '../../data/repositories/game_player_movement_repository.dart';
import '../../data/repositories/game_player_repository.dart';
import '../../data/repositories/game_turn_repository.dart';
import '../../data/services/game_events_socket.dart';
import '../../data/side_effects/game_combat_side_effect.dart';
import '../../data/side_effects/game_debug_shake_side_effect.dart';
import '../../data/side_effects/game_finish_notification_side_effect.dart';
import '../../data/side_effects/game_item_dropped_disconnected_side_effect.dart';
import '../../data/side_effects/game_movement_side_effect.dart';
import '../../data/side_effects/game_pending_item_pickup_side_effect.dart';
import '../../data/side_effects/game_player_abandoned_board_side_effect.dart';
import '../../data/side_effects/game_player_movement_animation_completed_side_effect.dart';
import '../../data/side_effects/game_player_movement_animation_side_effect.dart';
import '../../data/side_effects/game_reachable_cells_overlay_side_effect.dart';
import '../../data/side_effects/game_session_event_side_effect.dart';
import '../../data/side_effects/game_session_play_game_side_effect.dart';
import '../../data/side_effects/game_turn_auto_forward_side_effect.dart';
import '../../data/side_effects/game_turn_auto_selection_side_effect.dart';
import '../../data/side_effects/game_trap_flow_side_effect.dart';
import '../../data/side_effects/game_turn_end_item_cleanup_side_effect.dart';
import '../../data/side_effects/game_turn_side_effect.dart';
import '../../data/side_effects/game_turn_start_notification_side_effect.dart';
import '../../data/side_effects/game_virtual_player_move_side_effect.dart';
import '../../data/side_effects/game_virtual_player_turn_side_effect.dart';
import '../../data/side_effects/game_win_condition_side_effect.dart';
import '../context/game_session_scope_holder.dart';
import '../event_bus/game_session_event_bus.dart';

void registerGameSessionEventSideEffect(GetIt getIt) {
  getIt.registerLazySingleton<GameSessionEventSideEffect>(
    () => GameSessionEventSideEffect(
      appTransitionEventBus: getIt<AppTransitionEventBus>(),
      gameSessionEventBus: getIt<GameSessionEventBus>(),
      notificationIntentSink: getIt<NotificationIntentSink>(),
      gameSessionScopeHolder: getIt<GameSessionScopeHolder>(),
    ),
  );
  getIt.get<GameSessionEventSideEffect>();
}

void registerGameSideEffects(
  GetIt scope,
  GetIt rootGetIt, {
  required String roomId,
  required String socketId,
  required bool isHost,
}) {
  scope.registerSingleton<GameSessionPlayGameSideEffect>(
    GameSessionPlayGameSideEffect(
      gameSessionEventBus: scope.get<GameSessionEventBus>(),
      gameEventsSocket: scope.get<GameEventsSocket>(),
    ),
    dispose: (se) => se.dispose(),
  );
  scope.registerSingleton<GamePlayerAbandonedBoardSideEffect>(
    GamePlayerAbandonedBoardSideEffect(
      gameSessionEventBus: scope.get<GameSessionEventBus>(),
      boardRepository: scope.get<GameBoardRepository>(),
      inventoryRepository: scope.get<GameInventoryRepository>(),
    ),
    dispose: (se) => se.dispose(),
  );
  scope.registerSingleton<GameMovementSideEffect>(
    GameMovementSideEffect(
      roomId: roomId,
      socketId: socketId,
      boardRepository: scope.get<GameBoardRepository>(),
      interactionRepository: scope.get<GameBoardInteractionRepository>(),
      inventoryRepository: scope.get<GameInventoryRepository>(),
      movementRepository: scope.get<GamePlayerMovementRepository>(),
    ),
    dispose: (se) => se.dispose(),
  );
  scope.registerSingleton<GameReachableCellsOverlaySideEffect>(
    GameReachableCellsOverlaySideEffect(
      roomId: roomId,
      socketId: socketId,
      gameSessionEventBus: scope.get<GameSessionEventBus>(),
      boardRepository: scope.get<GameBoardRepository>(),
      debugRepository: scope.get<GameDebugRepository>(),
      movementRepository: scope.get<GamePlayerMovementRepository>(),
      inventoryRepository: scope.get<GameInventoryRepository>(),
      turnRepository: scope.get<GameTurnRepository>(),
    ),
    dispose: (se) => se.dispose(),
  );
  scope.registerSingleton<GameCombatSideEffect>(
    GameCombatSideEffect(
      socketId: socketId,
      combatRepository: scope.get<GameCombatRepository>(),
      playerRepository: scope.get<GamePlayerRepository>(),
      movementRepository: scope.get<GamePlayerMovementRepository>(),
      metadataRepository: scope.get<GameMetadataRepository>(),
      gameSessionEventBus: scope.get<GameSessionEventBus>(),
    ),
    dispose: (se) => se.dispose(),
  );
  scope.registerSingleton<GameTurnStartNotificationSideEffect>(
    GameTurnStartNotificationSideEffect(
      eventsSocket: scope.get<GameEventsSocket>(),
      playerRepository: scope.get<GamePlayerRepository>(),
      notificationIntentSink: scope.get<NotificationCoordinator>(),
    ),
    dispose: (se) => se.dispose(),
  );
  scope.registerSingleton<GameVirtualPlayerTurnSideEffect>(
    GameVirtualPlayerTurnSideEffect(
      roomId: roomId,
      socketId: socketId,
      eventsSocket: scope.get<GameEventsSocket>(),
      playerRepository: scope.get<GamePlayerRepository>(),
      metadataRepository: scope.get<GameMetadataRepository>(),
      actionsRepository: scope.get<GameActionsRepository>(),
    ),
    dispose: (se) => se.dispose(),
  );
  scope.registerSingleton<GameTurnSideEffect>(
    GameTurnSideEffect(
      socketId: socketId,
      turnRepository: scope.get<GameTurnRepository>(),
      eventsSocket: scope.get<GameEventsSocket>(),
    ),
    dispose: (se) => se.dispose(),
  );
  scope.registerSingleton<GameTurnAutoForwardSideEffect>(
    GameTurnAutoForwardSideEffect(
      socketId: socketId,
      gameSessionEventBus: scope.get<GameSessionEventBus>(),
      actionsRepository: scope.get<GameActionsRepository>(),
      boardRepository: scope.get<GameBoardRepository>(),
      turnRepository: scope.get<GameTurnRepository>(),
      playerRepository: scope.get<GamePlayerRepository>(),
      metadataRepository: scope.get<GameMetadataRepository>(),
      eventsSocket: scope.get<GameEventsSocket>(),
    ),
    dispose: (se) => se.dispose(),
  );
  scope.registerSingleton<GameTurnAutoSelectionSideEffect>(
    GameTurnAutoSelectionSideEffect(
      socketId: socketId,
      eventsSocket: scope.get<GameEventsSocket>(),
      interactionRepository: scope.get<GameBoardInteractionRepository>(),
    ),
    dispose: (se) => se.dispose(),
  );
  scope.registerSingleton<GamePendingItemPickupSideEffect>(
    GamePendingItemPickupSideEffect(
      roomId: roomId,
      socketId: socketId,
      gameSessionEventBus: scope.get<GameSessionEventBus>(),
      boardRepository: scope.get<GameBoardRepository>(),
      inventoryRepository: scope.get<GameInventoryRepository>(),
      itemRepository: scope.get<GameItemRepository>(),
      notificationIntentSink: scope.get<NotificationCoordinator>(),
    ),
    dispose: (se) => se.dispose(),
  );
  scope.registerSingleton<GameWinConditionSideEffect>(
    GameWinConditionSideEffect(
      roomId: roomId,
      socketId: socketId,
      playerRepository: scope.get<GamePlayerRepository>(),
      inventoryRepository: scope.get<GameInventoryRepository>(),
      boardRepository: scope.get<GameBoardRepository>(),
      actionsRepository: scope.get<GameActionsRepository>(),
      metadataRepository: scope.get<GameMetadataRepository>(),
    ),
    dispose: (se) => se.dispose(),
  );
  scope.registerSingleton<GameFinishNotificationSideEffect>(
    GameFinishNotificationSideEffect(
      socketId: socketId,
      gameSessionEventBus: scope.get<GameSessionEventBus>(),
      notificationIntentSink: scope.get<NotificationCoordinator>(),
      appTransitionEventBus: rootGetIt.get<AppTransitionEventBus>(),
      gameSessionScopeHolder: rootGetIt.get<GameSessionScopeHolder>(),
      gamePlayerRepository: scope.get<GamePlayerRepository>(),
    ),
    dispose: (se) => se.dispose(),
  );
  scope.registerSingleton<GameVirtualPlayerMoveSideEffect>(
    GameVirtualPlayerMoveSideEffect(
      roomId: roomId,
      socketId: socketId,
      gameSessionEventBus: scope.get<GameSessionEventBus>(),
      gameMetadataRepository: scope.get<GameMetadataRepository>(),
      actionsRepository: scope.get<GameActionsRepository>(),
      combatRepository: scope.get<GameCombatRepository>(),
      itemRepository: scope.get<GameItemRepository>(),
    ),
    dispose: (se) => se.dispose(),
  );
  scope.registerSingleton<GamePlayerMovementAnimationSideEffect>(
    GamePlayerMovementAnimationSideEffect(
      gameSessionEventBus: scope.get<GameSessionEventBus>(),
      boardRepository: scope.get<GameBoardRepository>(),
      playerRepository: scope.get<GamePlayerRepository>(),
      interactionRepository: scope.get<GameBoardInteractionRepository>(),
    ),
    dispose: (se) => se.dispose(),
  );
  scope.registerSingleton<GamePlayerMovementAnimationCompletedSideEffect>(
    GamePlayerMovementAnimationCompletedSideEffect(
      socketId: socketId,
      gameSessionEventBus: scope.get<GameSessionEventBus>(),
      boardRepository: scope.get<GameBoardRepository>(),
      playerRepository: scope.get<GamePlayerRepository>(),
      interactionRepository: scope.get<GameBoardInteractionRepository>(),
    ),
    dispose: (se) => se.dispose(),
  );
  scope.registerSingleton<GameItemDroppedDisconnectedSideEffect>(
    GameItemDroppedDisconnectedSideEffect(
      gameSessionEventBus: scope.get<GameSessionEventBus>(),
      boardRepository: scope.get<GameBoardRepository>(),
      itemRepository: scope.get<GameItemRepository>(),
    ),
    dispose: (se) => se.dispose(),
  );
  scope.registerSingleton<GameTurnEndItemCleanupSideEffect>(
    GameTurnEndItemCleanupSideEffect(
      roomId: roomId,
      socketId: socketId,
      eventsSocket: scope.get<GameEventsSocket>(),
      boardRepository: scope.get<GameBoardRepository>(),
      itemRepository: scope.get<GameItemRepository>(),
      notificationCoordinator: scope.get<NotificationCoordinator>(),
    ),
    dispose: (se) => se.dispose(),
  );
  scope.registerSingleton<GameDebugShakeSideEffect>(
    GameDebugShakeSideEffect(
      socketId: socketId,
      metadataRepository: scope.get<GameMetadataRepository>(),
      debugRepository: scope.get<GameDebugRepository>(),
    ),
    dispose: (se) => se.dispose(),
  );
  scope.registerSingleton<GameTrapFlowSideEffect>(
    GameTrapFlowSideEffect(
      roomId: roomId,
      socketId: socketId,
      notificationCoordinator: scope.get<NotificationCoordinator>(),
      actionsRepository: scope.get<GameActionsRepository>(),
      movementRepository: scope.get<GamePlayerMovementRepository>(),
      boardRepository: scope.get<GameBoardRepository>(),
      playerRepository: scope.get<GamePlayerRepository>(),
      metadataRepository: scope.get<GameMetadataRepository>(),
      turnRepository: scope.get<GameTurnRepository>(),
      inventoryRepository: scope.get<GameInventoryRepository>(),
    ),
    dispose: (se) => se.dispose(),
  );
}
