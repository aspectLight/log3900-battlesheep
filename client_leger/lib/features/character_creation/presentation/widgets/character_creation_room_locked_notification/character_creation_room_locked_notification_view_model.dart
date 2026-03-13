import '../../../../../core/notification/notification_intent.dart';

class CharacterCreationRoomLockedNotificationViewModel {
  CharacterCreationRoomLockedNotificationViewModel({
    required CharacterCreationRoomLockedNotificationIntent intent,
    required void Function() onDismiss,
  }) : _intent = intent,
       _onDismiss = onDismiss;

  final CharacterCreationRoomLockedNotificationIntent _intent;
  final void Function() _onDismiss;

  CharacterCreationRoomLockedNotificationIntent get intent => _intent;

  void handleDismiss() {
    _onDismiss();
  }
}
