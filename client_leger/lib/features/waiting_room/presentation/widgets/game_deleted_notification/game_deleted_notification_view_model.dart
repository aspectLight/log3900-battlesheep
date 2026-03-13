import '../../../../../core/notification/notification_intent.dart';

class GameDeletedNotificationViewModel {
  GameDeletedNotificationViewModel({
    required WaitingRoomDeletedNotificationIntent intent,
    required void Function() onDismiss,
  })  : _intent = intent,
        _onDismiss = onDismiss;

  final WaitingRoomDeletedNotificationIntent _intent;
  final void Function() _onDismiss;

  WaitingRoomDeletedNotificationIntent get intent => _intent;

  void handleDismiss() {
    _onDismiss();
  }
}
