import 'dart:async';

import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/notification/notification_intent.dart';

class GameTurnNotificationViewModel {
  final TurnStartNotificationIntent intent;
  final void Function() onDismiss;

  final remainingSeconds = signal(0);
  Timer? _timer;

  GameTurnNotificationViewModel({
    required this.intent,
    required this.onDismiss,
  }) {
    remainingSeconds.value = intent.countdownSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final next = remainingSeconds.value - 1;
    if (next <= 0) {
      _cancelTimer();
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
