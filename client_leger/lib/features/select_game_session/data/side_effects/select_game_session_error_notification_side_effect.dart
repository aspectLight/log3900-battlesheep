import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../../../core/notification/notification_intent.dart';
import '../../../../core/notification/notification_intent_sink.dart';
import '../../core/event_bus/select_game_session_event_bus.dart';

class SelectGameSessionErrorNotificationSideEffect with DisposableSideEffect {
  final SelectGameSessionEventBus _eventBus;
  final NotificationIntentSink _notificationIntentSink;

  SelectGameSessionErrorNotificationSideEffect({
    required SelectGameSessionEventBus eventBus,
    required NotificationIntentSink notificationIntentSink,
  }) : _eventBus = eventBus,
       _notificationIntentSink = notificationIntentSink {
    trackSubscription(
      _eventBus.on<ConfirmSelectionFailed>().listen(_onConfirmSelectionFailed),
    );
  }

  void _onConfirmSelectionFailed(ConfirmSelectionFailed event) {
    _notificationIntentSink.addIntent(
      SelectGameSessionErrorNotificationIntent(event.failure),
    );
  }
}
