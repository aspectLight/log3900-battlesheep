import 'dart:async';

import 'package:get_it/get_it.dart';

import '../app_events/game_session_events.dart';
import '../context/game_history_record_holder.dart';
import '../context/game_session_data.dart';
import '../context/game_session_scope_holder.dart';
import '../di/game_session_module.dart';
import '../enums/player_leave_reason.dart';
import '../enums/session_end_reason.dart';
import '../../../../core/app_transition/auto_scope_coordinator.dart';
import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/connected_scope/session_scope_manager.dart';
import '../../../../core/notification/notification_coordinator.dart';
import '../../../../routing/app_navigator.dart';
import '../../../../routing/navigation_command.dart';
import '../../../game_history/data/repositories/game_history_repository.dart';
import '../../../statistics/core/app_events/statistics_events.dart';
import '../../data/reducers/game_metadata_state_reducer.dart';
import '../../data/repositories/game_metadata_repository.dart';
import '../../data/services/game_service.dart';
import '../../domain/models/game.dart';
import '../../domain/state/game_board_state.dart';

class GameSessionCoordinator
    extends
    AutoScopeCoordinator<
        GameSessionData,
        GameSessionEntryAppEvent,
        GameSessionCompletedAppEvent,
        GameSessionExitAppEvent> {
  GameSessionCoordinator({
    required this.getIt,
    required this.sessionScopeManager,
    required this.gameSessionScopeHolder,
    required this.appNavigator,
    required this.notificationCoordinator,
    required this.appTransitionEventBus,
    required this.gameService,
    required GameMetadataStateReducer gameMetadataStateReducer,
    required GameHistoryRepository gameHistoryRepository,
  })  : _gameMetadataStateReducer = gameMetadataStateReducer,
        _gameHistoryRepository = gameHistoryRepository;

  final GetIt getIt;
  @override
  final SessionScopeManager sessionScopeManager;
  final GameSessionScopeHolder gameSessionScopeHolder;
  final AppNavigator appNavigator;
  final NotificationCoordinator notificationCoordinator;
  final AppTransitionEventBus appTransitionEventBus;
  final GameService gameService;
  final GameMetadataStateReducer _gameMetadataStateReducer;
  final GameHistoryRepository _gameHistoryRepository;

  @override
  final String scopeName = 'game';

  @override
  void onScopeCreated(GetIt scope) {
    gameSessionScopeHolder.setScope(scope);
  }

  @override
  Future<GameSessionData?> onEntryImpl(GameSessionEntryAppEvent event) async {
    switch (event) {
      case StartGameSessionRequestedCommand(
        :final roomId,
        :final gameId,
        :final socketId,
        :final gameName,
        :final gameDescription,
      ):
        appNavigator.request(GoToGameLoading());
        appTransitionEventBus.fire(const GameSessionCompletedAppEvent());
        return GameSessionData(
          roomId: roomId,
          gameId: gameId,
          socketId: socketId,
          gameName: gameName,
          gameDescription: gameDescription,
        );
      case GameSessionStartConfirmedEvent(
        :final roomId,
        :final gameId,
        :final socketId,
        :final isHost,
        :final gameName,
        :final gameDescription,
      ):
        appNavigator.request(GoToGameLoading());
        appTransitionEventBus.fire(const GameSessionCompletedAppEvent());
        return GameSessionData(
          roomId: roomId,
          gameId: gameId,
          socketId: socketId,
          isHost: isHost,
          gameName: gameName,
          gameDescription: gameDescription,
        );
      case GameSessionLoadedEvent():
        appNavigator.request(GoToGame());
        return null;
    }
  }

  @override
  Future<void> onCompletedImpl(
    GameSessionCompletedAppEvent event,
    GameSessionData data,
  ) async {
    final scope = featureScope;
    if (scope == null) return;
    scope.registerLazySingleton<GameSessionData>(() => data);
    final game = await gameService.getGame(data.gameId);
    scope.registerLazySingleton<Game>(() => game);
    scope.registerLazySingleton<Board>(() => game.board);
    scope.registerLazySingleton<GameMetadataRepository>(
      () => GameMetadataRepository(
        reducer: _gameMetadataStateReducer,
        roomId: data.roomId,
        isCTF: game.isCTF,
        initialHostId: data.isHost ? data.socketId : '',
      ),
    );
    registerGameSessionScope(
      scope,
      getIt,
      roomId: data.roomId,
      socketId: data.socketId,
      isHost: data.isHost,
    );
    final modeStr = game.isCTF ? 'CTF' : 'Classique';
    final startDate = await _gameHistoryRepository.startGameHistory(modeStr);
    if (startDate.isNotEmpty) {
      scope.get<GameHistoryRecordHolder>().startDate = startDate;
    }
    bootstrapGameSessionScope(
      scope,
      roomId: data.roomId,
      isHost: data.isHost,
    );
    appTransitionEventBus.fire(const GameSessionEntryAppEvent.loaded());
  }

  @override
  Future<void> onExitImpl(
    GameSessionExitAppEvent event,
    GameSessionData data,
  ) async {
    final scope = featureScope;
    final startDate = scope?.get<GameHistoryRecordHolder>().startDate;
    if (startDate != null && startDate.isNotEmpty) {
      switch (event) {
        case GameFinishedEvent():
          await _gameHistoryRepository.endGameHistory(
            startDate: startDate,
            hasWon: false,
          );
        case LeaveGameSessionRequestedCommand(:final reason):
          if (reason == PlayerLeaveReason.abandoned) {
            await _gameHistoryRepository.abandonGameHistory(startDate);
          }
        case SessionTerminatedEvent(:final reason):
          if (reason == SessionEndReason.abandoned) {
            await _gameHistoryRepository.abandonGameHistory(startDate);
          }
      }
    }
    notificationCoordinator.clearScopeEntries();
    gameSessionScopeHolder.clearScope();
    switch (event) {
      case GameFinishedEvent(:final roomId, :final isCTF):
        appTransitionEventBus.fire(
          StatisticsEntryAppEvent.statisticsRequested(
            roomId: roomId,
            isCTF: isCTF,
          ),
        );
      case LeaveGameSessionRequestedCommand():
      case SessionTerminatedEvent():
        appNavigator.request(ExitToMainMenu());
    }
  }
}
