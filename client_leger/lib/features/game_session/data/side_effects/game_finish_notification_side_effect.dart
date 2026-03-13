import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../../../core/notification/notification_intent.dart';
import '../../../../core/notification/notification_intent_sink.dart';
import '../../core/app_events/game_session_events.dart';
import '../../core/event_bus/game_session_event_bus.dart';

class GameFinishNotificationSideEffect with DisposableSideEffect {
  final String _socketId;
  final GameSessionEventBus _gameSessionEventBus;
  final NotificationIntentSink _notificationIntentSink;
  final AppTransitionEventBus _appTransitionEventBus;

  GameFinishNotificationSideEffect({
    required String socketId,
    required GameSessionEventBus gameSessionEventBus,
    required NotificationIntentSink notificationIntentSink,
    required AppTransitionEventBus appTransitionEventBus,
  })  : _socketId = socketId,
        _gameSessionEventBus = gameSessionEventBus,
        _notificationIntentSink = notificationIntentSink,
        _appTransitionEventBus = appTransitionEventBus {
    trackSubscription(
      _gameSessionEventBus.on<GameSessionFinishedEvent>().listen(_onGameSessionFinished),
    );
  }

  void _onGameSessionFinished(GameSessionFinishedEvent e) {
    _notificationIntentSink.addIntent(
      FinishGameNotificationIntent(
        winnerId: e.winnerId,
        isCTF: e.isCTF,
        currentUserSocketId: _socketId,
        onComplete: () {
          _appTransitionEventBus.fire(
            GameSessionExitAppEvent.gameFinished(
              roomId: e.roomId,
              isCTF: e.isCTF,
            ),
          );
        },
      ),
    );
  }
}
