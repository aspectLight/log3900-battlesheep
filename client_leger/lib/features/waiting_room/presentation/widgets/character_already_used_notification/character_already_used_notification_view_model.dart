import '../../../../../core/notification/notification_intent.dart';

class CharacterAlreadyUsedNotificationViewModel {
  CharacterAlreadyUsedNotificationViewModel({
    required WaitingRoomReserveFailedNotificationIntent intent,
    required void Function() onDismiss,
  }) : _intent = intent,
       _onDismiss = onDismiss;

  final WaitingRoomReserveFailedNotificationIntent _intent;
  final void Function() _onDismiss;

  WaitingRoomReserveFailedNotificationIntent get intent => _intent;

  void handleDismiss() {
    _onDismiss();
  }
}
