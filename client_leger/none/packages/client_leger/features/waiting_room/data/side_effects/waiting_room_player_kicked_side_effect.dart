import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/enums/waiting_room_leave_reason.dart';
import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../../../core/notification/notification_intent.dart';
import '../../../../core/notification/notification_intent_sink.dart';
import '../../core/app_events/waiting_room_events.dart';
import '../../core/event_bus/waiting_room_event_bus.dart';

class WaitingRoomPlayerKickedSideEffect with DisposableSideEffect {
  WaitingRoomPlayerKickedSideEffect({
    required AppTransitionEventBus appTransitionEventBus,
    required WaitingRoomEventBus waitingRoomEventBus,
    required NotificationIntentSink notificationIntentSink,
  }) : _appTransitionEventBus = appTransitionEventBus,
       _notificationIntentSink = notificationIntentSink {
    trackSubscription(
      waitingRoomEventBus.on<WaitingRoomPlayerKickedEvent>().listen(_onKicked),
    );
  }

  final AppTransitionEventBus _appTransitionEventBus;
  final NotificationIntentSink _notificationIntentSink;

  void _onKicked(WaitingRoomPlayerKickedEvent _) {
    _notificationIntentSink.addIntent(
      WaitingRoomPlayerKickedNotificationIntent(
        onDismissAction: () => _appTransitionEventBus.fire(
          const WaitingRoomExitAppEvent.systemLeave(
            WaitingRoomLeaveReason.kicked,
          ),
        ),
      ),
    );
  }
}
