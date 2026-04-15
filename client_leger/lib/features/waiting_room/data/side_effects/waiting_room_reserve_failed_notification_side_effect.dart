import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../../../core/notification/notification_intent.dart';
import '../../../../core/notification/notification_intent_sink.dart';
import '../../core/event_bus/waiting_room_event_bus.dart';

class WaitingRoomReserveFailedNotificationSideEffect with DisposableSideEffect {
  WaitingRoomReserveFailedNotificationSideEffect({
    required WaitingRoomEventBus waitingRoomEventBus,
    required NotificationIntentSink notificationIntentSink,
  }) : _waitingRoomEventBus = waitingRoomEventBus,
       _notificationIntentSink = notificationIntentSink {
    trackSubscription(
      _waitingRoomEventBus.on<WaitingRoomReserveFailedEvent>().listen(
        _onReserveFailed,
      ),
    );
  }

  final WaitingRoomEventBus _waitingRoomEventBus;
  final NotificationIntentSink _notificationIntentSink;

  void _onReserveFailed(WaitingRoomReserveFailedEvent event) {
    _notificationIntentSink.addIntent(
      WaitingRoomReserveFailedNotificationIntent(event.failure),
    );
  }
}
