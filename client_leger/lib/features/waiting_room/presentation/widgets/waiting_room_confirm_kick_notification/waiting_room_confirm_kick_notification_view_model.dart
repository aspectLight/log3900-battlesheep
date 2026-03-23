import '../../../../../core/notification/notification_intent.dart';

class WaitingRoomConfirmKickNotificationViewModel {
  WaitingRoomConfirmKickNotificationViewModel({
    required WaitingRoomConfirmKickNotificationIntent intent,
    required void Function() onDismiss,
  })  : _intent = intent,
        _onDismiss = onDismiss;

  final WaitingRoomConfirmKickNotificationIntent _intent;
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
