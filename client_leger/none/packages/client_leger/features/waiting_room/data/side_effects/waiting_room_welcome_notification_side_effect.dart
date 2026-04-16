import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../../../core/notification/notification_intent.dart';
import '../../../../core/notification/notification_intent_sink.dart';
import '../../core/event_bus/waiting_room_event_bus.dart';

class WaitingRoomWelcomeNotificationSideEffect with DisposableSideEffect {
  WaitingRoomWelcomeNotificationSideEffect({
    required WaitingRoomEventBus waitingRoomEventBus,
    required NotificationIntentSink notificationIntentSink,
  }) : _notificationIntentSink = notificationIntentSink {
    trackSubscription(
      waitingRoomEventBus.on<WaitingRoomWelcomeRequestedEvent>().listen(
        _onWelcomeRequested,
      ),
    );
  }

  final NotificationIntentSink _notificationIntentSink;

  void _onWelcomeRequested(WaitingRoomWelcomeRequestedEvent event) {
    _notificationIntentSink.addIntent(
      const WaitingRoomWelcomeNotificationIntent(),
    );
  }
}
