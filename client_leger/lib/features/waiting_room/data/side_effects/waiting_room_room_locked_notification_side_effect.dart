import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../../../core/notification/notification_intent.dart';
import '../../../../core/notification/notification_intent_sink.dart';
import '../../core/event_bus/waiting_room_event_bus.dart';

class WaitingRoomRoomLockedNotificationSideEffect with DisposableSideEffect {
  WaitingRoomRoomLockedNotificationSideEffect({
    required WaitingRoomEventBus waitingRoomEventBus,
    required NotificationIntentSink notificationIntentSink,
  }) : _notificationIntentSink = notificationIntentSink {
    trackSubscription(
      waitingRoomEventBus
          .on<WaitingRoomRoomLockedNotificationRequestedEvent>()
          .listen(_onRoomLockedRequested),
    );
  }

  final NotificationIntentSink _notificationIntentSink;

  void _onRoomLockedRequested(
    WaitingRoomRoomLockedNotificationRequestedEvent event,
  ) {
    _notificationIntentSink.addIntent(
      WaitingRoomRoomLockedNotificationIntent(
        onDismissAction: event.onDismissAction,
      ),
    );
  }
}
