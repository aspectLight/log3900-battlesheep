import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/enums/waiting_room_leave_reason.dart';
import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../../../core/notification/notification_intent.dart';
import '../../../../core/notification/notification_intent_sink.dart';
import '../../core/app_events/waiting_room_events.dart';
import '../../core/event_bus/waiting_room_event_bus.dart';

class WaitingRoomCanceledSideEffect with DisposableSideEffect {
  WaitingRoomCanceledSideEffect({
    required AppTransitionEventBus appTransitionEventBus,
    required WaitingRoomEventBus waitingRoomEventBus,
    required NotificationIntentSink notificationIntentSink,
  })  : _appTransitionEventBus = appTransitionEventBus,
        _notificationIntentSink = notificationIntentSink {
    trackSubscription(
      waitingRoomEventBus.on<WaitingRoomCanceledEvent>().listen(_onCanceled),
    );
  }

  final AppTransitionEventBus _appTransitionEventBus;
  final NotificationIntentSink _notificationIntentSink;

  void _onCanceled(WaitingRoomCanceledEvent _) {
    _notificationIntentSink.addIntent(
      WaitingRoomDeletedNotificationIntent(
        onDismissAction: () => _appTransitionEventBus.fire(
          const WaitingRoomExitAppEvent.systemLeave(
            WaitingRoomLeaveReason.roomCanceled,
          ),
        ),
      ),
    );
  }
}
