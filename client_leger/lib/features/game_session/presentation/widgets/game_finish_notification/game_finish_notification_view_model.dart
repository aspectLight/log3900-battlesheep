import 'dart:async';

import 'package:signals_flutter/signals_flutter.dart';

import '../../../core/constants/game_rules_constants.dart';
import '../../../../../core/notification/notification_intent.dart';

class GameFinishNotificationViewModel {
  final FinishGameNotificationIntent intent;
  final void Function() onDismiss;

  final remainingSeconds = signal(0);
  Timer? _timer;
  bool _isDisposed = false;

  GameFinishNotificationViewModel({
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
    if (_isDisposed) return;
    final next = remainingSeconds.value - 1;
    if (next <= 0) {
      _cancelTimer();
      if (_isDisposed) return;
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
    _isDisposed = true;
    _cancelTimer();
  }

  bool get hasWon => intent.currentUserSocketId == intent.winnerId;
}
