import '../../../../../core/notification/notification_intent.dart';
import '../../../core/exceptions/join_game_session_failure.dart';

class JoinGameSessionFailureNotificationViewModel {
  JoinGameSessionFailureNotificationViewModel({
    required this.intent,
    required this.onDismiss,
  });

  final JoinGameSessionFailureNotificationIntent intent;
  final void Function() onDismiss;

  JoinGameSessionFailure get failure => intent.failure;

  void dismiss() => onDismiss();
}
