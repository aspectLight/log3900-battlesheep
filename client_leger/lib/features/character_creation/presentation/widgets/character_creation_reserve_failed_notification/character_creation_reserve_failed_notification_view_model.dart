import '../../../../../core/notification/notification_intent.dart';

class CharacterCreationReserveFailedNotificationViewModel {
  CharacterCreationReserveFailedNotificationViewModel({
    required CharacterCreationReserveFailedNotificationIntent intent,
    required void Function() onDismiss,
  }) : _intent = intent,
       _onDismiss = onDismiss;

  final CharacterCreationReserveFailedNotificationIntent _intent;
  final void Function() _onDismiss;

  CharacterCreationReserveFailedNotificationIntent get intent => _intent;

  void handleDismiss() {
    _onDismiss();
  }
}
