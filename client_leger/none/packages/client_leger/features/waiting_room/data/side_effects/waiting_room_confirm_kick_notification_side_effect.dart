import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../../../core/modal/modal_intent_sink.dart';
import '../../core/event_bus/waiting_room_event_bus.dart';
import '../../core/modal/waiting_room_modal_intents.dart';

class WaitingRoomConfirmKickNotificationSideEffect with DisposableSideEffect {
  WaitingRoomConfirmKickNotificationSideEffect({
    required WaitingRoomEventBus waitingRoomEventBus,
    required ModalIntentSink modalIntentSink,
  }) : _modalIntentSink = modalIntentSink {
    trackSubscription(
      waitingRoomEventBus.on<WaitingRoomConfirmKickRequestedEvent>().listen(
        _onConfirmKickRequested,
      ),
    );
  }

  final ModalIntentSink _modalIntentSink;

  void _onConfirmKickRequested(WaitingRoomConfirmKickRequestedEvent event) {
    _modalIntentSink.addIntent(
      WaitingRoomConfirmKickModalIntent(
        onConfirmAction: event.onConfirmAction,
        onCancelAction: event.onCancelAction,
      ),
    );
  }
}
