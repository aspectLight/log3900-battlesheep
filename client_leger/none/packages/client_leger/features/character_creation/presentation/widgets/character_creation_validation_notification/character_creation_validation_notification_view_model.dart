import '../../../../../core/notification/notification_intent.dart';

class CharacterCreationValidationNotificationViewModel {
  CharacterCreationValidationNotificationViewModel({
    required CharacterCreationValidationNotificationIntent intent,
    required void Function() onDismiss,
  }) : _intent = intent,
       _onDismiss = onDismiss;

  final CharacterCreationValidationNotificationIntent _intent;
  final void Function() _onDismiss;

  CharacterCreationValidationNotificationIntent get intent => _intent;

  void handleDismiss() {
    _onDismiss();
  }
}
