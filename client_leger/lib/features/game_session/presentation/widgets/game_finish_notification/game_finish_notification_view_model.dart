import 'dart:async';

import 'package:signals_flutter/signals_flutter.dart';

import '../../../core/constants/game_rules_constants.dart';
import '../../../core/constants/game_team_constants.dart';
import '../../../../../core/notification/notification_intent.dart';
import '../../../data/repositories/game_player_repository.dart';
import '../../../domain/state/game_player_state.dart';

class GameFinishNotificationViewModel {
  final FinishGameNotificationIntent intent;
  final void Function() onDismiss;
  final GamePlayerRepository _playerRepository;

  final remainingSeconds = signal(0);
  Timer? _timer;

  GameFinishNotificationViewModel({
    required this.intent,
    required this.onDismiss,
    required GamePlayerRepository playerRepository,
  }) : _playerRepository = playerRepository {
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

  GamePlayerState get _playerState => _playerRepository.state.value;

  bool get hasWon => intent.currentUserSocketId == intent.winnerId;

  String get winnerName {
    final winner = _playerState.players
        .where((p) => p.id == intent.winnerId)
        .first;
    return winner.name;
  }

  String get winnerTeamName {
    final winner = _playerState.players
        .where((p) => p.id == intent.winnerId)
        .firstOrNull;
    return GameTeamConstants.toDisplayName(winner?.team) ?? '';
  }
}
