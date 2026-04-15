import '../../../../../core/notification/notification_intent.dart';

class WaitingRoomRoomLockedNotificationViewModel {
  WaitingRoomRoomLockedNotificationViewModel({
    required WaitingRoomRoomLockedNotificationIntent intent,
    required void Function() onDismiss,
  }) : _intent = intent,
       _onDismiss = onDismiss;

  final WaitingRoomRoomLockedNotificationIntent _intent;
  final void Function() _onDismiss;

  void handleDismiss() {
    _intent.onDismissAction?.call();
    _onDismiss();
  }
}
