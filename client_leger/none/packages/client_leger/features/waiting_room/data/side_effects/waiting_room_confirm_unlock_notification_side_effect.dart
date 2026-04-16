import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../../../core/modal/modal_intent_sink.dart';
import '../../core/event_bus/waiting_room_event_bus.dart';
import '../../core/modal/waiting_room_modal_intents.dart';

class WaitingRoomConfirmUnlockNotificationSideEffect with DisposableSideEffect {
  WaitingRoomConfirmUnlockNotificationSideEffect({
    required WaitingRoomEventBus waitingRoomEventBus,
    required ModalIntentSink modalIntentSink,
  }) : _modalIntentSink = modalIntentSink {
    trackSubscription(
      waitingRoomEventBus.on<WaitingRoomConfirmUnlockRequestedEvent>().listen(
        _onConfirmUnlockRequested,
      ),
    );
  }

  final ModalIntentSink _modalIntentSink;

  void _onConfirmUnlockRequested(WaitingRoomConfirmUnlockRequestedEvent event) {
    _modalIntentSink.addIntent(
      WaitingRoomConfirmUnlockModalIntent(
        onConfirmAction: event.onConfirmAction,
        onCancelAction: event.onCancelAction,
      ),
    );
  }
}
