import '../../../../../core/notification/notification_intent.dart';

class SelectGameSessionErrorNotificationViewModel {
  SelectGameSessionErrorNotificationViewModel({
    required SelectGameSessionErrorNotificationIntent intent,
    required void Function() onDismiss,
  }) : _intent = intent,
       _onDismiss = onDismiss;

  final SelectGameSessionErrorNotificationIntent _intent;
  final void Function() _onDismiss;

  SelectGameSessionErrorNotificationIntent get intent => _intent;

  void handleDismiss() {
    _onDismiss();
  }
}
