import 'dart:async';

import 'package:get_it/get_it.dart';

import '../app_events/game_session_events.dart';
import '../context/drop_in_join_sync_holder.dart';
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
import '../../../../core/notification/notification_intent.dart';
import '../../../../routing/app_navigator.dart';
import '../../../../routing/navigation_command.dart';
import '../../../game_history/data/repositories/game_history_repository.dart';
import '../../../statistics/core/app_events/statistics_events.dart';
import '../../data/models/extensions/game_events_dto_extensions.dart';
import '../../data/models/dto/game_dto.dart';
import '../../data/models/extensions/game_dto_extensions.dart';
import '../../data/reducers/game_metadata_state_reducer.dart';
import '../../data/repositories/game_board_repository.dart';
import '../../data/repositories/game_inventory_repository.dart';
import '../../data/repositories/game_metadata_repository.dart';
import '../../data/repositories/game_player_repository.dart';
import '../../data/repositories/game_rewards_holder.dart';
import '../../../../core/services/log_service.dart';
import '../../data/repositories/game_turn_repository.dart';
import '../../data/services/game_service.dart';
import '../../domain/events/game_events.dart';
import '../../domain/models/game.dart';
import '../../domain/services/game_start_board_items_resolver.dart';
import '../../domain/state/game_board_state.dart';
import '../../../join_game_session/core/exceptions/join_game_session_failure.dart';

class GameSessionCoordinator
    extends
        AutoScopeCoordinator<
          GameSessionData,
          GameSessionEntryAppEvent,
          GameSessionCompletedAppEvent,
          GameSessionExitAppEvent
        > {
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
  }) : _gameMetadataStateReducer = gameMetadataStateReducer,
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
  bool get tearDownStaleFeatureScopeOnEntry => true;

  @override
  void onScopeCreated(GetIt scope) {
    gameSessionScopeHolder.setScope(scope);
    appTransitionEventBus.fire(const GameSessionCompletedAppEvent());
  }

  @override
  void onScopeDropped() {
    gameSessionScopeHolder.clearScope();
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
        :final gameRoomHostId,
        :final gameName,
        :final gameDescription,
      ):
        appNavigator.request(GoToGameLoading());
        return GameSessionData(
          roomId: roomId,
          gameId: gameId,
          socketId: socketId,
          isHost: isHost,
          gameRoomHostId: gameRoomHostId,
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
    try {
      if (scope.isRegistered<GameSessionData>()) return;
      final fetchedGame = await gameService.getGame(data.gameId);
      // Drop-in (and similar paths) pass empty title/description; the UI reads
      // [GameSessionData], not the domain [Game], so fill from the REST payload.
      final sessionData = data.copyWith(
        gameName: data.gameName.isNotEmpty ? data.gameName : fetchedGame.name,
        gameDescription: data.gameDescription.isNotEmpty
            ? data.gameDescription
            : fetchedGame.description,
      );
      scope.registerLazySingleton<GameSessionData>(() => sessionData);
      final resolvedItems = resolveRandomBoardItems(
        items: fetchedGame.initialItems,
        board: fetchedGame.board,
        roomId: data.roomId,
      );
      final game = Game(
        id: fetchedGame.id,
        name: fetchedGame.name,
        description: fetchedGame.description,
        mode: fetchedGame.mode,
        board: fetchedGame.board,
        initialItems: resolvedItems,
        privacy: fetchedGame.privacy,
        owner: fetchedGame.owner,
        actionPoints: fetchedGame.actionPoints,
        modificationDate: fetchedGame.modificationDate,
      );
      scope.registerLazySingleton<Game>(() => game);
      scope.registerLazySingleton<Board>(() => game.board);
      final dropInSync = getIt<DropInJoinSyncHolder>();
      final effectiveHostId = data.gameRoomHostId.isNotEmpty
          ? data.gameRoomHostId
          : dropInSync.gameRoomHostId;
      scope.registerLazySingleton<GameMetadataRepository>(
        () => GameMetadataRepository(
          reducer: _gameMetadataStateReducer,
          roomId: data.roomId,
          isCTF: game.isCTF,
          initialHostId: effectiveHostId.isNotEmpty
              ? effectiveHostId
              : (data.isHost ? data.socketId : ''),
        ),
      );
      final shouldEmitPlayGame = effectiveHostId.isNotEmpty
          ? data.socketId == effectiveHostId
          : data.isHost;
      registerGameSessionScope(
        scope,
        getIt,
        roomId: data.roomId,
        socketId: data.socketId,
        isHost: shouldEmitPlayGame,
      );
      final modeStr = game.isCTF ? 'CTF' : 'Classique';
      final startDate = await _gameHistoryRepository.startGameHistory(modeStr);
      if (startDate.isNotEmpty) {
        scope.get<GameHistoryRecordHolder>().startDate = startDate;
      }
      bootstrapGameSessionScope(
        scope,
        roomId: data.roomId,
        isHost: shouldEmitPlayGame,
      );
      _applyDropInJoinSyncIfNeeded(scope, data.roomId);
      appTransitionEventBus.fire(const GameSessionEntryAppEvent.loaded());
    } on Object catch (e, st) {
      LogService.e('[GameSessionCoordinator] onCompletedImpl failed', e, st);
      getIt<DropInJoinSyncHolder>().clear();
      final sessionScope = sessionScopeManager.currentScope;
      if (sessionScope != null) {
        await sessionScope.dropScope(scopeName);
      }
      markFeatureScopeReleased();
      onScopeDropped();
      notificationCoordinator.addIntent(
        const JoinGameSessionFailureNotificationIntent(
          UnknownJoinGameSessionFailure('Game session bootstrap failed'),
        ),
      );
      appNavigator.request(ExitToMainMenu());
    }
  }

  void _applyDropInJoinSyncIfNeeded(GetIt scope, String roomId) {
    final holder = getIt<DropInJoinSyncHolder>();
    final raw = holder.playersRaw;
    if (raw == null || raw.isEmpty) {
      holder.clear();
      return;
    }
    final currentBoardRaw = holder.currentBoardRaw;
    if (currentBoardRaw != null) {
      try {
        final boardSizeRaw = currentBoardRaw['size'];
        final matrixRaw = currentBoardRaw['matrix'];
        if (boardSizeRaw is! num || matrixRaw is! List<dynamic>) {
          throw const FormatException('Invalid currentBoard snapshot');
        }
        final boardDto = BoardDto.fromJson(currentBoardRaw);
        final game = scope.get<Game>();
        final gameDto = GameDto(
          id: game.id,
          name: game.name,
          description: game.description,
          mode: game.isCTF ? 'ctf' : 'classique',
          board: boardDto,
          modificationDate: game.modificationDate,
          privacy: game.privacy,
          owner: game.owner,
          actionPoints: game.actionPoints,
        );
        final rebuiltGame = gameDto.toEntity();
        final dropInResolvedItems = resolveRandomBoardItems(
          items: rebuiltGame.initialItems,
          board: rebuiltGame.board,
          roomId: roomId,
        );
        scope.get<GameBoardRepository>().replaceBoardAndItems(
          board: rebuiltGame.board,
          items: dropInResolvedItems,
        );
      } on Object catch (_) {
        unawaited(Future<void>.value());
      }
    }
    final spawned = raw.toPlayerSpawnedDto().toEntity();
    scope.get<GamePlayerRepository>().applyPlayersSpawned(spawned);
    scope.get<GameBoardRepository>().applyPlayersSpawned(spawned);
    scope.get<GameInventoryRepository>().applyPlayersSpawned(spawned);
    final currentId = holder.currentPlayerId;
    if (currentId != null && currentId.isNotEmpty) {
      scope.get<GamePlayerRepository>().applyCurrentPlayerChanged(
        CurrentPlayerChangedEvent(playerId: currentId),
      );
      final turnRepo = scope.get<GameTurnRepository>();
      turnRepo.state.value = turnRepo.state.value.copyWith(
        currentPlayerId: currentId,
      );
    }
    final tr = holder.turnTimeRemaining;
    final phase = holder.turnCountdownPhase;
    if (tr != null && (phase == 'break' || phase == 'play')) {
      final turnRepo = scope.get<GameTurnRepository>();
      if (phase == 'break') {
        turnRepo.applyStartingCountdown(
          UpdateStartingCountdownEvent(countdown: tr),
        );
      } else {
        turnRepo.applyGameCountdown(UpdateCountdownEvent(countdown: tr));
      }
    }
    holder.clear();
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
    if (event is LeaveGameSessionRequestedCommand &&
        event.reason == PlayerLeaveReason.abandoned) {
      notificationCoordinator.addIntent(
        const GameCanceledNotificationIntent(isSelfLeave: true),
      );
    }
    notificationCoordinator.clearScopeEntries();
    switch (event) {
      case GameFinishedEvent(
        :final roomId,
        :final isCTF,
        :final winnerId,
        :final currentUserSocketId,
        :final statisticsPlayerName,
      ):
        final capturedRewards = getIt<GameRewardsHolder>().captured;
        LogService.d('[GameSessionCoord] onExitImpl: capturedRewards has ${capturedRewards.rewards.length} reward(s), entryFee=${capturedRewards.entryFee}, pool=${capturedRewards.pool}');
        appTransitionEventBus.fire(
          StatisticsEntryAppEvent.statisticsRequested(
            roomId: roomId,
            isCTF: isCTF,
            winnerId: winnerId,
            currentUserSocketId: currentUserSocketId,
            statisticsPlayerName: statisticsPlayerName,
            capturedRewards: capturedRewards,
          ),
        );
      case LeaveGameSessionRequestedCommand():
      case SessionTerminatedEvent():
        appNavigator.request(ExitToMainMenu());
    }
  }
}
