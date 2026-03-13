import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../../../core/modal/modal_intent_sink.dart';
import '../../core/event_bus/waiting_room_event_bus.dart';
import '../../core/modal/waiting_room_modal_intents.dart';

class WaitingRoomConfirmLeaveNotificationSideEffect with DisposableSideEffect {
  WaitingRoomConfirmLeaveNotificationSideEffect({
    required WaitingRoomEventBus waitingRoomEventBus,
    required ModalIntentSink modalIntentSink,
  }) : _modalIntentSink = modalIntentSink {
    trackSubscription(
      waitingRoomEventBus
          .on<WaitingRoomConfirmLeaveRequestedEvent>()
          .listen(_onConfirmLeaveRequested),
    );
  }

  final ModalIntentSink _modalIntentSink;

  void _onConfirmLeaveRequested(WaitingRoomConfirmLeaveRequestedEvent event) {
    _modalIntentSink.addIntent(
      WaitingRoomConfirmLeaveModalIntent(
        onConfirmAction: event.onConfirmAction,
        onCancelAction: event.onCancelAction,
      ),
    );
  }
}
