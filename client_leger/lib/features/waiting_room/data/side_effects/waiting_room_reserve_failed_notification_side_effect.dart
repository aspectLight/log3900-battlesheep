import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../../../core/notification/notification_intent.dart';
import '../../../../core/notification/notification_intent_sink.dart';
import '../../core/event_bus/waiting_room_event_bus.dart';
import '../../core/exceptions/waiting_room_failure.dart';
import '../services/waiting_room_socket.dart';

/// Shows reserve-avatar errors from the event bus (use-case path) and from the
/// server push `avatarReservationFailed` (ACK + push). Short dedupe window
/// avoids double toasts when both paths run for the same failure.
class WaitingRoomReserveFailedNotificationSideEffect with DisposableSideEffect {
  WaitingRoomReserveFailedNotificationSideEffect({
    required WaitingRoomEventBus waitingRoomEventBus,
    required WaitingRoomSocket waitingRoomSocket,
    required NotificationIntentSink notificationIntentSink,
  }) : _notificationIntentSink = notificationIntentSink {
    trackSubscription(
      waitingRoomEventBus.on<WaitingRoomReserveFailedEvent>().listen(
        _onReserveFailedFromBus,
      ),
    );
    trackSubscription(
      waitingRoomSocket.avatarReservationFailedStream.listen((failure) {
        if (failure is! CharacterAlreadyReservedWaitingRoomFailure) {
          return;
        }
        _onReserveFailedFromSocket(failure);
      }),
    );
  }

  final NotificationIntentSink _notificationIntentSink;

  String? _lastDedupKey;
  DateTime? _lastDedupAt;

  void _onReserveFailedFromBus(WaitingRoomReserveFailedEvent event) {
    _emitIfNotDuplicate(event.failure);
  }

  void _onReserveFailedFromSocket(WaitingRoomFailure failure) {
    _emitIfNotDuplicate(failure);
  }

  void _emitIfNotDuplicate(WaitingRoomFailure failure) {
    final key = '${failure.runtimeType}:${failure.devMessage}';
    final now = DateTime.now();
    if (_lastDedupKey == key &&
        _lastDedupAt != null &&
        now.difference(_lastDedupAt!) < const Duration(milliseconds: 250)) {
      return;
    }
    _lastDedupKey = key;
    _lastDedupAt = now;

    if (failure is CharacterAlreadyReservedWaitingRoomFailure) {
      _notificationIntentSink.addIntent(
        WaitingRoomReserveFailedNotificationIntent(failure),
      );
    } else {
      _notificationIntentSink.addIntent(
        WaitingRoomFailureNotificationIntent(failure: failure),
      );
    }
  }
}
