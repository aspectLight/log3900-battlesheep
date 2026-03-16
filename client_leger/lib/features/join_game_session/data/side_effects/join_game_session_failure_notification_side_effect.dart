import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../../../core/notification/notification_intent.dart';
import '../../../../core/notification/notification_intent_sink.dart';
import '../../core/event_bus/join_game_session_event_bus.dart';

class JoinGameSessionFailureNotificationSideEffect
    with DisposableSideEffect {
  JoinGameSessionFailureNotificationSideEffect({
    required JoinGameSessionEventBus eventBus,
    required NotificationIntentSink notificationIntentSink,
  })  : _eventBus = eventBus,
        _notificationIntentSink = notificationIntentSink {
    trackSubscription(
      _eventBus.on<JoinGameSessionFailureEvent>().listen(_onFailure),
    );
  }

  final JoinGameSessionEventBus _eventBus;
  final NotificationIntentSink _notificationIntentSink;

  void _onFailure(JoinGameSessionFailureEvent event) {
    _notificationIntentSink.addIntent(
      JoinGameSessionFailureNotificationIntent(event.failure),
    );
  }
}
