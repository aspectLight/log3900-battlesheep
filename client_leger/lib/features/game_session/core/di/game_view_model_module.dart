import 'package:get_it/get_it.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/notification/notification_coordinator.dart';
import '../../../../core/services/socket_service.dart';
import '../../data/repositories/game_actions_repository.dart';
import '../../data/repositories/game_board_interaction_repository.dart';
import '../../data/repositories/game_board_repository.dart';
import '../../data/repositories/game_board_selected_cell_repository.dart';
import '../../data/repositories/game_combat_repository.dart';
import '../../data/repositories/game_debug_repository.dart';
import '../../data/repositories/game_inventory_repository.dart';
import '../context/game_session_data.dart';
import '../../data/repositories/game_metadata_repository.dart';
import '../../data/repositories/game_player_repository.dart';
import '../../data/repositories/game_turn_repository.dart';
import '../../domain/use_cases/debug_teleport_player_use_case.dart';
import '../../domain/use_cases/execute_board_action_use_case.dart';
import '../../domain/use_cases/forward_turn_use_case.dart';
import '../../domain/use_cases/move_player_use_case.dart';
import '../../presentation/screens/game_screen/game_screen_view_model.dart';
import '../../presentation/widgets/game_actions/game_actions_view_model.dart';
import '../../presentation/widgets/game_board/game_board_view_model.dart';
import '../../presentation/widgets/game_cell_detail/game_cell_detail_view_model.dart';
import '../../presentation/widgets/game_combat/game_combat_view_model.dart';
import '../../presentation/widgets/game_debug_mode_strip/game_debug_mode_strip_view_model.dart';
import '../../presentation/widgets/game_info_panel/game_info_panel_view_model.dart';
import '../../presentation/widgets/game_inventory_full_discard_notification/game_inventory_full_discard_notification_view_model.dart';
import '../../presentation/widgets/game_player_cards_hud/game_player_cards_hud_view_model.dart';
import '../../presentation/widgets/game_player_hud/game_player_hud_view_model.dart';
import '../../presentation/widgets/game_player_inventory/game_player_inventory_view_model.dart';
import '../../presentation/widgets/game_timer/game_timer_view_model.dart';

void registerGameSessionRootViewModels(GetIt getIt) {
  getIt.registerFactory<GameInventoryFullDiscardNotificationViewModel>(
    () => GameInventoryFullDiscardNotificationViewModel(
      getIt<NotificationCoordinator>(),
    ),
  );
}

void registerGameSessionScopeViewModels(
  GetIt scope,
  GetIt rootGetIt, {
  required String socketId,
}) {
  scope.registerFactory<GameScreenViewModel>(
    () => GameScreenViewModel(
      combatRepository: scope.get<GameCombatRepository>(),
    ),
  );
  scope.registerFactory<GamePlayerInventoryViewModel>(
    () => GamePlayerInventoryViewModel(
      inventoryRepository: scope.get<GameInventoryRepository>(),
      playerId: socketId,
    ),
  );
  scope.registerFactory<GamePlayerCardsHudViewModel>(
    () => GamePlayerCardsHudViewModel(
      playerRepository: scope.get<GamePlayerRepository>(),
      turnRepository: scope.get<GameTurnRepository>(),
      sessionRepository: scope.get<GameMetadataRepository>(),
      inventoryRepository: scope.get<GameInventoryRepository>(),
    ),
  );
  scope.registerFactory<GameActionsViewModel>(
    () => GameActionsViewModel(
      turnRepository: scope.get<GameTurnRepository>(),
      interactionRepository: scope.get<GameBoardInteractionRepository>(),
      boardRepository: scope.get<GameBoardRepository>(),
      forwardTurnUseCase: scope.get<ForwardTurnUseCase>(),
      socketId: socketId,
    ),
  );
  scope.registerFactory<GameTimerViewModel>(
    () => GameTimerViewModel(turnRepository: scope.get<GameTurnRepository>()),
  );
  scope.registerFactory<GameBoardViewModel>(
    () => GameBoardViewModel(
      gameBoardSelectedCellRepository: scope
          .get<GameBoardSelectedCellRepository>(),
      boardRepository: scope.get<GameBoardRepository>(),
      playerRepository: scope.get<GamePlayerRepository>(),
      turnRepository: scope.get<GameTurnRepository>(),
      interactionRepository: scope.get<GameBoardInteractionRepository>(),
      debugRepository: scope.get<GameDebugRepository>(),
      executeBoardActionUseCase: scope.get<ExecuteBoardActionUseCase>(),
      movePlayerUseCase: scope.get<MovePlayerUseCase>(),
      debugTeleportPlayerUseCase: scope.get<DebugTeleportPlayerUseCase>(),
    ),
  );
  scope.registerFactory<GamePlayerHudWidgetViewModel>(
    () => GamePlayerHudWidgetViewModel(
      playerRepository: scope.get<GamePlayerRepository>(),
      socketId: socketId,
    ),
  );
  scope.registerFactory<GameInfoPanelViewModel>(
    () => GameInfoPanelViewModel(
      appTransitionEventBus: rootGetIt.get<AppTransitionEventBus>(),
      sessionData: scope.get<GameSessionData>(),
      actionsRepository: scope.get<GameActionsRepository>(),
      boardRepository: scope.get<GameBoardRepository>(),
      playerRepository: scope.get<GamePlayerRepository>(),
      turnRepository: scope.get<GameTurnRepository>(),
      metadataRepository: scope.get<GameMetadataRepository>(),
    ),
  );
  scope.registerFactory<GameCellDetailWidgetViewModel>(
    () => GameCellDetailWidgetViewModel(
      gameBoardSelectedCellRepository: scope
          .get<GameBoardSelectedCellRepository>(),
      boardRepository: scope.get<GameBoardRepository>(),
      playerRepository: scope.get<GamePlayerRepository>(),
      socketService: rootGetIt.get<SocketService>(),
    ),
  );
  scope.registerFactory<GameCombatViewModel>(
    () => GameCombatViewModel(
      combatRepository: scope.get<GameCombatRepository>(),
      playerRepository: scope.get<GamePlayerRepository>(),
      turnRepository: scope.get<GameTurnRepository>(),
      socketId: socketId,
    ),
  );
  scope.registerFactory<GameDebugModeStripViewModel>(
    () => GameDebugModeStripViewModel(
      debugRepository: scope.get<GameDebugRepository>(),
    ),
  );
}
