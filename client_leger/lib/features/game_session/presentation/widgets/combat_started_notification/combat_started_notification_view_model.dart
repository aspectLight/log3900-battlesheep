import 'dart:async';

import '../../../core/constants/combat_ui_constants.dart';
import '../../../../../core/notification/notification_intent.dart';

class CombatStartedNotificationViewModel {
  final CombatStartedNotificationIntent intent;
  final void Function() onDismiss;

  CombatStartedNotificationViewModel({
    required this.intent,
    required this.onDismiss,
  }) {
    _timer = Timer(
      const Duration(milliseconds: CombatUiConstants.notificationDurationMs),
      onDismiss,
    );
  }

  Timer? _timer;

  void dismiss() {
    _timer?.cancel();
    _timer = null;
    onDismiss();
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
