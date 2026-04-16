import 'package:fpdart/fpdart.dart';

import '../../../../core/constants/avatar_assets.dart';
import '../../../../core/enums/avatar.dart';
import '../../../../core/enums/item_type.dart';
import '../../core/enums/stat_type.dart';
import '../../../../core/helpers/functional_programming.dart';
import '../../core/typedefs/combat_typedefs.dart';
import '../../domain/state/game_combat_state.dart';
import '../../domain/state/game_player_state.dart';
import '../../domain/state/game_turn_state.dart';
import '../ui_models/widget_states/game_combat_ui_state.dart';

GameCombatUiState toGameCombatUiModel(
  GameCombatState combatState,
  GamePlayerState playerState,
  GameTurnState turnState,
  String currentPlayerId,
) {
  if (!combatState.isCombatMode) return const GameCombatInactive();
  final ctxOpt = _extractCombatContext(
    combatState,
    playerState,
    turnState,
    currentPlayerId,
  );
  return ctxOpt.when(
    none: () => const GameCombatInactive(),
    some: (ctx) => _buildActive(combatState, ctx, playerState),
  );
}

Option<CombatContext> _extractCombatContext(
  GameCombatState combatState,
  GamePlayerState playerState,
  GameTurnState turnState,
  String currentPlayerId,
) {
  return Option.Do(($) {
    final attackerId = $(combatState.attackerId);
    final defenderId = $(combatState.defenderId);
    final combatCurrentPlayerId = $(combatState.currentPlayerId);
    final isPlayerTurn = combatCurrentPlayerId == currentPlayerId;
    final isInitiator = attackerId == currentPlayerId;
    final enemyId = isInitiator ? defenderId : attackerId;
    final enemy = $(playerState.findById(enemyId));
    return (
      selfId: currentPlayerId,
      isPlayerTurn: isPlayerTurn,
      isInitiator: isInitiator,
      enemy: enemy,
    );
  });
}

GameCombatActive _buildActive(
  GameCombatState combatState,
  CombatContext ctx,
  GamePlayerState playerState,
) {
  final enemy = ctx.enemy;
  final hasEnemyBarbedWire = enemy.inventory.any(
    (item) => item?.type == ItemType.barbedWire,
  );
  final endOverlay = combatState is CombatResolved
      ? _buildEndOverlay(combatState, playerState, ctx.selfId)
      : null;
  final inEndOverlay = endOverlay != null;
  final canFleeBase =
      ctx.isPlayerTurn &&
      combatState.flightAttemptsLeft > 0 &&
      (!hasEnemyBarbedWire || ctx.isInitiator);
  final canFlee = canFleeBase && !inEndOverlay;
  final attackSuccess = combatState.lastAttackSuccess.getOrElse(() => false);
  final flightAttemptSuccessOpt = combatState.lastFlightAttemptSuccess;
  final isPlayerAttacking = combatState is CombatWithResult
      ? combatState.lastActorIdRaw == ctx.selfId
      : ctx.isPlayerTurn;
  return GameCombatActive(
    isCombatPlayerTurn: ctx.isPlayerTurn,
    combatCountdown: combatState.combatCountdown,
    flightAttemptsLeft: combatState.flightAttemptsLeft,
    isCombatInitiator: ctx.isInitiator,
    showResults: combatState is CombatWithResult,
    isAttackSuccess: attackSuccess,
    showFlightAttemptResult: flightAttemptSuccessOpt.isSome() && !inEndOverlay,
    isFlightAttemptSuccess: flightAttemptSuccessOpt.getOrElse(() => false),
    canAttack: ctx.isPlayerTurn && !inEndOverlay,
    canFlee: canFlee,
    hasEnemyBarbedWire: hasEnemyBarbedWire,
    enemyInfo: _buildEnemyInfo(enemy),
    combatResults: _buildResults(combatState, isPlayerAttacking),
    notification: GameCombatNotificationUi.empty,
    endOverlay: endOverlay,
  );
}

GameCombatEndOverlay _buildEndOverlay(
  CombatResolved resolved,
  GamePlayerState playerState,
  String selfId,
) {
  final winnerDisplayName = playerState
      .findById(resolved.winnerId)
      .map((p) => p.name)
      .getOrElse(() => '');
  final enemyId =
      selfId == resolved.winnerId ? resolved.loserId : resolved.winnerId;
  final enemyDisplayName = playerState
      .findById(enemyId)
      .map((p) => p.name)
      .getOrElse(() => '');
  if (!resolved.isByFlight && selfId == resolved.winnerId) {
    return const GameCombatEndOverlay(kind: GameCombatEndOverlayKind.victory);
  }
  if (!resolved.isByFlight && selfId == resolved.loserId) {
    return GameCombatEndOverlay(
      kind: GameCombatEndOverlayKind.defeat,
      winnerName: winnerDisplayName,
    );
  }
  if (resolved.isByFlight && selfId == resolved.winnerId) {
    return const GameCombatEndOverlay(kind: GameCombatEndOverlayKind.fled);
  }
  return GameCombatEndOverlay(
    kind: GameCombatEndOverlayKind.enemyFled,
    enemyName: enemyDisplayName,
  );
}

GameCombatEnemyInfoUi _buildEnemyInfo(GamePlayer enemy) {
  final avatar = Avatar.values.byName(enemy.characterType.name);
  final d6 = enemy.diceChoice;
  return GameCombatEnemyInfoUi(
    id: enemy.id,
    name: enemy.name,
    avatarPath: Option.of(AvatarAssets.avatarPath(avatar)),
    stats: enemy.stats,
    d6DiceChoice: d6,
    d4DiceChoice: d6 == StatType.attack ? StatType.defense : StatType.attack,
  );
}

GameCombatResultsUi _buildResults(
  GameCombatState combatState,
  bool isPlayerAttacking,
) {
  return Option.Do(($) {
    final attack = $(combatState.lastAttackValue);
    final defense = $(combatState.lastDefenseValue);
    return GameCombatResultsUi(
      attackValue: attack,
      defenseValue: defense,
      isPlayerAttacking: isPlayerAttacking,
    );
  }).fold(() => GameCombatResultsUi.empty, (x) => x);
}
