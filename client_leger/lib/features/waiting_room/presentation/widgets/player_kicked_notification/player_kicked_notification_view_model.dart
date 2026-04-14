import '../../../../../core/notification/notification_intent.dart';

class PlayerKickedNotificationViewModel {
  PlayerKickedNotificationViewModel({
    required WaitingRoomPlayerKickedNotificationIntent intent,
    required void Function() onDismiss,
  }) : _intent = intent,
       _onDismiss = onDismiss;

  final WaitingRoomPlayerKickedNotificationIntent _intent;
  final void Function() _onDismiss;

  WaitingRoomPlayerKickedNotificationIntent get intent => _intent;

  void handleDismiss() {
    _onDismiss();
  }
}
