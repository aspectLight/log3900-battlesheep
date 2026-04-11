import 'package:get_it/get_it.dart';

import '../../../../core/di/scoped_projection_subscriptions.dart';
import '../../../../core/modal/modal_widget_registry.dart';
import '../modal/game_info_modal_intent.dart';
import '../../presentation/widgets/game_info_panel/game_info_panel.dart';
import '../../data/projections/game_board_events_projection.dart';
import '../../data/projections/game_combat_events_projection.dart';
import '../../data/projections/game_debug_events_projection.dart';
import '../../data/projections/game_item_events_projection.dart';
import '../../data/projections/game_movement_events_projection.dart';
import '../../data/projections/game_player_events_projection.dart';
import '../../data/projections/game_session_events_projection.dart';
import '../../data/projections/game_spawn_events_projection.dart';
import '../../data/projections/game_turn_events_projection.dart';
import '../../data/side_effects/game_debug_shake_side_effect.dart';
import '../../data/side_effects/game_finish_notification_side_effect.dart';
import '../../data/side_effects/game_session_play_game_side_effect.dart';
import '../../data/side_effects/game_item_dropped_disconnected_side_effect.dart';
import '../../data/side_effects/game_movement_side_effect.dart';
import '../../data/side_effects/game_pending_item_pickup_side_effect.dart';
import '../../data/side_effects/game_player_abandoned_board_side_effect.dart';
import '../../data/side_effects/game_reachable_cells_overlay_side_effect.dart';
import '../../data/side_effects/game_player_movement_animation_completed_side_effect.dart';
import '../../data/side_effects/game_player_movement_animation_side_effect.dart';
import '../../data/side_effects/game_turn_auto_forward_side_effect.dart';
import '../../data/side_effects/game_turn_auto_selection_side_effect.dart';
import '../../data/side_effects/game_turn_end_item_cleanup_side_effect.dart';
import '../../data/side_effects/game_turn_side_effect.dart';
import '../../data/side_effects/game_combat_started_notification_side_effect.dart';
import '../../data/side_effects/game_turn_start_notification_side_effect.dart';
import '../../data/side_effects/game_virtual_player_move_side_effect.dart';
import '../../data/side_effects/game_virtual_player_turn_side_effect.dart';
import '../../data/side_effects/game_win_condition_side_effect.dart';
import '../context/game_history_record_holder.dart';
import '../context/game_session_scope_holder.dart';
import '../event_bus/game_session_event_bus.dart';
import 'game_session_coordinator_module.dart';
import 'game_projection_module.dart' as proj;
import 'game_reducer_module.dart';
import 'game_repositories_module.dart';
import 'game_services_module.dart';
import 'game_session_event_bus_module.dart';
import 'game_side_effect_module.dart' as se;
import 'game_state_repository_module.dart' as state_repo;
import 'game_use_case_module.dart' as uc;
import 'game_view_model_module.dart' as vm;

class _GameSessionScopeBootstrapped {
  const _GameSessionScopeBootstrapped();
}

void registerGameSessionRoot(GetIt getIt) {
  getIt.registerLazySingleton<GameSessionScopeHolder>(
    GameSessionScopeHolder.new,
  );
  registerGameRootServices(getIt);
  registerGameReducers(getIt);
  registerGameSessionEventBus(getIt);
  registerGameSessionCoordinator(getIt);
  se.registerGameSessionEventSideEffect(getIt);
  vm.registerGameSessionRootViewModels(getIt);
  registerGameSessionModals(getIt);
}

void registerGameSessionModals(GetIt getIt) {
  final registry = getIt<ModalWidgetRegistry>();
  registry.register<GameInfoModalIntent>(
    (context, intent, onClose) => GameInfoPanel(onClose: onClose),
  );
}

void registerGameSessionScope(
  GetIt scope,
  GetIt rootGetIt, {
  required String roomId,
  required String socketId,
  required bool isHost,
}) {
  scope.registerLazySingleton<GameHistoryRecordHolder>(
    GameHistoryRecordHolder.new,
  );
  registerGameScopeServices(scope, rootGetIt);
  registerGameScopeRepositories(scope);
  state_repo.registerGameStateRepositories(scope);
  vm.registerGameSessionScopeViewModels(scope, rootGetIt, socketId: socketId);
  proj.registerGameProjections(scope, rootGetIt, socketId: socketId);
  se.registerGameSideEffects(
    scope,
    rootGetIt,
    roomId: roomId,
    socketId: socketId,
    isHost: isHost,
  );
  uc.registerGameUseCases(scope, rootGetIt, roomId: roomId, socketId: socketId);
}

void bootstrapGameSessionScope(
  GetIt scope, {
  required String roomId,
  required bool isHost,
}) {
  if (scope.isRegistered<_GameSessionScopeBootstrapped>()) {
    return;
  }
  scope.registerSingleton<_GameSessionScopeBootstrapped>(
    const _GameSessionScopeBootstrapped(),
  );
  scope.get<GameSessionPlayGameSideEffect>();
  registerScopedProjectionSubscriptions(scope, [
    ...scope.get<GameTurnEventsProjection>().subscribe(),
    ...scope.get<GameSpawnEventsProjection>().subscribe(),
    ...scope.get<GameSessionEventsProjection>().subscribe(),
    ...scope.get<GamePlayerEventsProjection>().subscribe(),
    ...scope.get<GameBoardEventsProjection>().subscribe(),
    ...scope.get<GameMovementEventsProjection>().subscribe(),
    ...scope.get<GameCombatEventsProjection>().subscribe(),
    ...scope.get<GameItemEventsProjection>().subscribe(),
    ...scope.get<GameDebugEventsProjection>().subscribe(),
  ]);
  scope.get<GameMovementSideEffect>();
  scope.get<GameReachableCellsOverlaySideEffect>();
  scope.get<GamePlayerAbandonedBoardSideEffect>();
  scope.get<GameTurnStartNotificationSideEffect>();
  scope.get<GameCombatStartedNotificationSideEffect>();
  scope.get<GameVirtualPlayerTurnSideEffect>();
  scope.get<GameTurnSideEffect>();
  scope.get<GameTurnAutoForwardSideEffect>();
  scope.get<GameTurnAutoSelectionSideEffect>();
  scope.get<GamePendingItemPickupSideEffect>();
  scope.get<GameWinConditionSideEffect>();
  scope.get<GameFinishNotificationSideEffect>();
  scope.get<GameVirtualPlayerMoveSideEffect>();
  scope.get<GamePlayerMovementAnimationSideEffect>();
  scope.get<GamePlayerMovementAnimationCompletedSideEffect>();
  scope.get<GameItemDroppedDisconnectedSideEffect>();
  scope.get<GameTurnEndItemCleanupSideEffect>();
  scope.get<GameDebugShakeSideEffect>();
  scope.get<GameSessionEventBus>().fire(
    GameSessionScopeReady(roomId: roomId, isHost: isHost),
  );
}

void registerGameStateRepositories(GetIt scope) =>
    state_repo.registerGameStateRepositories(scope);
