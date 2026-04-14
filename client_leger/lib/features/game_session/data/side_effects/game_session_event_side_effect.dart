import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../../../core/notification/notification_intent.dart';
import '../../../../core/notification/notification_intent_sink.dart';
import '../../core/context/game_session_data.dart';
import '../../core/context/game_session_scope_holder.dart';
import '../../core/app_events/game_session_events.dart';
import '../../core/enums/session_end_reason.dart';
import '../../core/event_bus/game_session_event_bus.dart';

class GameSessionEventSideEffect with DisposableSideEffect {
  GameSessionEventSideEffect({
    required AppTransitionEventBus appTransitionEventBus,
    required GameSessionEventBus gameSessionEventBus,
    required NotificationIntentSink notificationIntentSink,
    required GameSessionScopeHolder gameSessionScopeHolder,
  }) : _appTransitionEventBus = appTransitionEventBus,
       _notificationIntentSink = notificationIntentSink,
       _gameSessionScopeHolder = gameSessionScopeHolder {
    trackSubscription(
      gameSessionEventBus.on<GameSessionCanceled>().listen((event) {
        final scope = _gameSessionScopeHolder.scope;
        if (scope == null || !scope.isRegistered<GameSessionData>()) return;
        final sessionData = scope.get<GameSessionData>();
        if (sessionData.socketId == event.playerId) return;
        _notificationIntentSink.addIntent(
          const GameCanceledNotificationIntent(),
        );
        _appTransitionEventBus.fire(
          const GameSessionExitAppEvent.sessionTerminated(
            SessionEndReason.canceled,
          ),
        );
      }),
    );
    trackSubscription(
      gameSessionEventBus.on<GameSessionAbandoned>().listen((_) {
        _appTransitionEventBus.fire(
          const GameSessionExitAppEvent.sessionTerminated(
            SessionEndReason.abandoned,
          ),
        );
      }),
    );
  }

  final AppTransitionEventBus _appTransitionEventBus;
  final NotificationIntentSink _notificationIntentSink;
  final GameSessionScopeHolder _gameSessionScopeHolder;
}
