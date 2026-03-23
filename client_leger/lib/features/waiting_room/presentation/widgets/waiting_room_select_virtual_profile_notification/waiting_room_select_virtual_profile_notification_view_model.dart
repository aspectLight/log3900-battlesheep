import '../../../../../core/notification/notification_intent.dart';

class WaitingRoomSelectVirtualProfileNotificationViewModel {
  WaitingRoomSelectVirtualProfileNotificationViewModel({
    required WaitingRoomSelectVirtualProfileNotificationIntent intent,
    required void Function() onDismiss,
  })  : _intent = intent,
        _onDismiss = onDismiss;

  final WaitingRoomSelectVirtualProfileNotificationIntent _intent;
  final void Function() _onDismiss;

  void handleAggressive() {
    _intent.onAggressiveAction();
    _onDismiss();
  }

  void handleDefensive() {
    _intent.onDefensiveAction();
    _onDismiss();
  }
}
