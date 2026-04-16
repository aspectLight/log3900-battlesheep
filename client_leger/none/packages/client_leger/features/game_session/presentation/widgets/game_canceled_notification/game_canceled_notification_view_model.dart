import 'dart:async';

import 'package:signals_flutter/signals_flutter.dart';

import '../../../core/constants/game_rules_constants.dart';
import '../../../../../core/notification/notification_intent.dart';

class GameCanceledNotificationViewModel {
  final GameCanceledNotificationIntent intent;
  final void Function() onDismiss;

  final remainingSeconds = signal(0);
  Timer? _timer;

  GameCanceledNotificationViewModel({
    required this.intent,
    required this.onDismiss,
  }) {
    remainingSeconds.value =
        (GameRulesConstants.defaultNotificationDurationMs /
                GameRulesConstants.msToSeconds)
            .round();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final next = remainingSeconds.value - 1;
    if (next <= 0) {
      _cancelTimer();
      intent.onComplete?.call();
      onDismiss();
    } else {
      remainingSeconds.value = next;
    }
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    _cancelTimer();
  }
}
