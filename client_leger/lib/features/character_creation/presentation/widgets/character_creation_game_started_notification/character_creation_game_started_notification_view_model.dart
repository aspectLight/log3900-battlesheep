import '../../../../../core/notification/notification_intent.dart';

class CharacterCreationGameStartedNotificationViewModel {
  CharacterCreationGameStartedNotificationViewModel({
    required CharacterCreationGameStartedNotificationIntent intent,
    required void Function() onDismiss,
  }) : _intent = intent,
       _onDismiss = onDismiss;

  final CharacterCreationGameStartedNotificationIntent _intent;
  final void Function() _onDismiss;

  CharacterCreationGameStartedNotificationIntent get intent => _intent;

  void handleDismiss() {
    _onDismiss();
  }
}
