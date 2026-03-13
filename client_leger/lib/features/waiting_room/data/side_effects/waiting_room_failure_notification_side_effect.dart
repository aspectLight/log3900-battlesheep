import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../../../core/notification/notification_intent.dart';
import '../../../../core/notification/notification_intent_sink.dart';
import '../../core/event_bus/waiting_room_event_bus.dart';

class WaitingRoomFailureNotificationSideEffect with DisposableSideEffect {
  WaitingRoomFailureNotificationSideEffect({
    required WaitingRoomEventBus waitingRoomEventBus,
    required NotificationIntentSink notificationIntentSink,
  }) : _notificationIntentSink = notificationIntentSink {
    trackSubscription(
      waitingRoomEventBus
          .on<WaitingRoomFailureNotificationRequestedEvent>()
          .listen(_onFailureRequested),
    );
  }

  final NotificationIntentSink _notificationIntentSink;

  void _onFailureRequested(WaitingRoomFailureNotificationRequestedEvent event) {
    _notificationIntentSink.addIntent(
      WaitingRoomFailureNotificationIntent(
        failure: event.failure,
      ),
    );
  }
}
