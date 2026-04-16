import 'package:fpdart/fpdart.dart';

import '../../../core/enums/stat_type.dart';

sealed class GameCombatUiState {
  const GameCombatUiState();
}

enum GameCombatEndOverlayKind { victory, defeat, fled, enemyFled }

class GameCombatEndOverlay {
  final GameCombatEndOverlayKind kind;
  final String winnerName;
  final String enemyName;

  const GameCombatEndOverlay({
    required this.kind,
    this.winnerName = '',
    this.enemyName = '',
  });
}

class GameCombatInactive extends GameCombatUiState {
  const GameCombatInactive();
}

class GameCombatActive extends GameCombatUiState {
  final bool isCombatPlayerTurn;
  final int combatCountdown;
  final int flightAttemptsLeft;
  final bool isCombatInitiator;
  final bool showResults;
  final bool isAttackSuccess;
  final bool showFlightAttemptResult;
  final bool isFlightAttemptSuccess;
  final bool canAttack;
  final bool canFlee;
  final bool hasEnemyBarbedWire;
  final GameCombatEnemyInfoUi enemyInfo;
  final GameCombatResultsUi combatResults;
  final GameCombatNotificationUi notification;
  final GameCombatEndOverlay? endOverlay;

  const GameCombatActive({
    required this.isCombatPlayerTurn,
    required this.combatCountdown,
    required this.flightAttemptsLeft,
    required this.isCombatInitiator,
    required this.showResults,
    required this.isAttackSuccess,
    required this.showFlightAttemptResult,
    required this.isFlightAttemptSuccess,
    required this.canAttack,
    required this.canFlee,
    required this.hasEnemyBarbedWire,
    required this.enemyInfo,
    required this.combatResults,
    required this.notification,
    this.endOverlay,
  });
}

class GameCombatEnemyInfoUi {
  final String id;
  final String name;
  final Option<String> avatarPath;
  final Map<StatType, int> stats;
  final StatType d6DiceChoice;
  final StatType d4DiceChoice;

  const GameCombatEnemyInfoUi({
    required this.id,
    required this.name,
    required this.avatarPath,
    required this.stats,
    required this.d6DiceChoice,
    required this.d4DiceChoice,
  });
}

class GameCombatResultsUi {
  final int attackValue;
  final int defenseValue;
  final bool isPlayerAttacking;

  const GameCombatResultsUi({
    required this.attackValue,
    required this.defenseValue,
    required this.isPlayerAttacking,
  });

  static const empty = GameCombatResultsUi(
    attackValue: 0,
    defenseValue: 0,
    isPlayerAttacking: false,
  );
}

class GameCombatNotificationUi {
  final String title;
  final String message;
  final bool isSuccess;
  final bool isWinLossNotification;

  const GameCombatNotificationUi({
    required this.title,
    required this.message,
    required this.isSuccess,
    this.isWinLossNotification = false,
  });

  static const empty = GameCombatNotificationUi(
    title: '',
    message: '',
    isSuccess: false,
  );
}
