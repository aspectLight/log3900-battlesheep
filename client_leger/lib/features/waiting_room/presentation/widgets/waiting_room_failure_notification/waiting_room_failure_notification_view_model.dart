import '../../../../../core/notification/notification_intent.dart';

class WaitingRoomFailureNotificationViewModel {
  WaitingRoomFailureNotificationViewModel({
    required WaitingRoomFailureNotificationIntent intent,
    required void Function() onDismiss,
  })  : _intent = intent,
        _onDismiss = onDismiss;

  final WaitingRoomFailureNotificationIntent _intent;
  final void Function() _onDismiss;

  WaitingRoomFailureNotificationIntent get intent => _intent;

  void handleDismiss() {
    _onDismiss();
  }
}
