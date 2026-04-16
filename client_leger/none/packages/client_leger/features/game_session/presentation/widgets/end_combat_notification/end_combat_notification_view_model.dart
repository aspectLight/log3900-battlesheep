import 'dart:async';

import 'package:signals_flutter/signals_flutter.dart';

import '../../../core/constants/combat_ui_constants.dart';
import '../../../../../core/notification/notification_intent.dart';
import '../../../data/repositories/game_player_repository.dart';

class EndCombatNotificationViewModel {
  final EndCombatNotificationIntent intent;
  final void Function() onDismiss;
  final GamePlayerRepository _playerRepository;

  final remainingSeconds = signal(0);
  Timer? _timer;

  EndCombatNotificationViewModel({
    required this.intent,
    required this.onDismiss,
    required GamePlayerRepository playerRepository,
  }) : _playerRepository = playerRepository {
    remainingSeconds.value = (CombatUiConstants.notificationDurationMs / 1000)
        .round();
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

  void dismiss() {
    _cancelTimer();
    onDismiss();
  }

  void dispose() {
    _cancelTimer();
  }

  late final hasWon = computed<bool>(
    () => !intent.isByFlight && intent.currentUserSocketId == intent.winnerId,
  );

  late final hasLost = computed<bool>(
    () => !intent.isByFlight && intent.currentUserSocketId == intent.loserId,
  );

  late final hasFled = computed<bool>(
    () => intent.isByFlight && intent.currentUserSocketId == intent.winnerId,
  );

  late final enemyFled = computed<bool>(
    () => intent.isByFlight && intent.currentUserSocketId == intent.loserId,
  );

  late final winnerName = computed<String>(() {
    final playerState = _playerRepository.state.value;
    final winner = playerState.players
        .where((p) => p.id == intent.winnerId)
        .first;
    return winner.name;
  });

  late final enemyName = computed<String>(() {
    final enemyId = intent.currentUserSocketId == intent.winnerId
        ? intent.loserId
        : intent.winnerId;
    final playerState = _playerRepository.state.value;
    final enemy = playerState.players.where((p) => p.id == enemyId).first;
    return enemy.name;
  });
}
