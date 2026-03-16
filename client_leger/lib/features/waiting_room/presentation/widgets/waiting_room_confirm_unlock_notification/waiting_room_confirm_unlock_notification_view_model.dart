import '../../../../../core/notification/notification_intent.dart';

class WaitingRoomConfirmUnlockNotificationViewModel {
  WaitingRoomConfirmUnlockNotificationViewModel({
    required WaitingRoomConfirmUnlockNotificationIntent intent,
    required void Function() onDismiss,
  })  : _intent = intent,
        _onDismiss = onDismiss;

  final WaitingRoomConfirmUnlockNotificationIntent _intent;
  final void Function() _onDismiss;

  void handleConfirm() {
    _intent.onConfirmAction();
    _onDismiss();
  }

  void handleCancel() {
    _intent.onCancelAction();
    _onDismiss();
  }
}
