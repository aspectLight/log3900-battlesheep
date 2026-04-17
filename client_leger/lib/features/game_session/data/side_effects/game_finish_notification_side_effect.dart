import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../../../core/notification/notification_intent.dart';
import '../../../../core/notification/notification_intent_sink.dart';
import '../../core/constants/game_team_constants.dart';
import '../../core/app_events/game_session_events.dart';
import '../../core/context/game_session_scope_holder.dart';
import '../../core/event_bus/game_session_event_bus.dart';
import '../repositories/game_player_repository.dart';

class GameFinishNotificationSideEffect with DisposableSideEffect {
  final String _socketId;
  final GameSessionEventBus _gameSessionEventBus;
  final NotificationIntentSink _notificationIntentSink;
  final AppTransitionEventBus _appTransitionEventBus;
  final GameSessionScopeHolder _gameSessionScopeHolder;
  final GamePlayerRepository _gamePlayerRepository;

  GameFinishNotificationSideEffect({
    required String socketId,
    required GameSessionEventBus gameSessionEventBus,
    required NotificationIntentSink notificationIntentSink,
    required AppTransitionEventBus appTransitionEventBus,
    required GameSessionScopeHolder gameSessionScopeHolder,
    required GamePlayerRepository gamePlayerRepository,
  }) : _socketId = socketId,
       _gameSessionEventBus = gameSessionEventBus,
       _notificationIntentSink = notificationIntentSink,
       _appTransitionEventBus = appTransitionEventBus,
       _gameSessionScopeHolder = gameSessionScopeHolder,
       _gamePlayerRepository = gamePlayerRepository {
    trackSubscription(
      _gameSessionEventBus.on<GameSessionFinishedEvent>().listen(
        _onGameSessionFinished,
      ),
    );
  }

  void _onGameSessionFinished(GameSessionFinishedEvent e) {
    final winner = _gamePlayerRepository.state.value.players
        .where((p) => p.id == e.winnerId)
        .firstOrNull;
    _notificationIntentSink.addIntent(
      FinishGameNotificationIntent(
        winnerId: e.winnerId,
        winnerName: winner?.name ?? '',
        winnerTeamName: GameTeamConstants.toDisplayName(winner?.team) ?? '',
        isCTF: e.isCTF,
        currentUserSocketId: _socketId,
        onComplete: () {
          if (_gameSessionScopeHolder.scope == null) return;
          final String statisticsPlayerName = _gamePlayerRepository
              .state
              .value
              .players
              .where((p) => p.id == _socketId)
              .firstOrNull
              ?.name ?? '';
          _appTransitionEventBus.fire(
            GameSessionExitAppEvent.gameFinished(
              roomId: e.roomId,
              isCTF: e.isCTF,
              winnerId: e.winnerId,
              currentUserSocketId: _socketId,
              statisticsPlayerName: statisticsPlayerName,
            ),
          );
        },
      ),
    );
  }
}
