import 'package:fpdart/fpdart.dart';

import '../../domain/events/game_combat_events.dart';
import '../../domain/state/game_combat_state.dart';

class GameCombatStateReducer {
  GameCombatState reduce(GameCombatState previous, Object event) {
    if (event is CombatTurnStartedEvent) {
      return _reduceCombatTurnStarted(previous, event);
    }
    if (event is EndCombatResultEvent) {
      return _reduceEndCombatResult(previous, event);
    }
    if (event is AttackResultEvent) {
      return _reduceAttackResult(previous, event);
    }
    if (event is FlightAttemptResultEvent) {
      return _reduceFlightAttemptResult(previous, event);
    }
    if (event is CombatCountdownEvent) {
      return _reduceCombatCountdown(previous, event);
    }
    if (event is CombatResultsClearedEvent) {
      return _reduceCombatResultsCleared(previous, event);
    }
    if (event is FlightAttemptFeedbackClearedEvent) {
      return _reduceFlightAttemptFeedbackCleared(previous, event);
    }
    return previous;
  }

  GameCombatState _reduceCombatTurnStarted(
    GameCombatState previous,
    CombatTurnStartedEvent event,
  ) {
    return CombatActive(
      combatRoomId: event.combatRoomId,
      attackerId: event.attackerId,
      defenderId: event.defenderId,
      currentPlayerId: event.currentPlayerId,
      currentOpponentId: event.currentOpponentId,
      combatCountdown: previous.combatCountdown,
      flightAttemptsLeft: previous.flightAttemptsLeft,
    );
  }

  GameCombatState _reduceEndCombatResult(
    GameCombatState previous,
    EndCombatResultEvent event,
  ) {
    return const CombatIdle();
  }

  GameCombatState _reduceAttackResult(
    GameCombatState previous,
    AttackResultEvent event,
  ) {
    return previous.when(
      idle: (s) => s,
      active: (active) => CombatWithResult(
        combatRoomId: active.combatRoomIdRaw,
        attackerId: active.attackerIdRaw,
        defenderId: active.defenderIdRaw,
        currentPlayerId: active.currentPlayerIdRaw,
        currentOpponentId: active.currentOpponentIdRaw,
        combatCountdown: active.combatCountdown,
        flightAttemptsLeft: active.flightAttemptsLeft,
        lastFlightAttemptSuccess: active.lastFlightAttemptSuccess,
        lastActorId: active.currentPlayerIdRaw,
        lastTargetId: active.currentOpponentIdRaw,
        lastAttackSuccess: event.isAttackSuccess,
        lastOpponentHealthPoints: event.opponentHealthPoints,
        lastAttackValue: event.attackValue,
        lastDefenseValue: event.defenseValue,
      ),
      withResult: (withResult) => withResult.copyWith(
        lastAttackSuccess: event.isAttackSuccess,
        lastOpponentHealthPoints: event.opponentHealthPoints,
        lastAttackValue: event.attackValue,
        lastDefenseValue: event.defenseValue,
        lastActorId: withResult.currentPlayerIdRaw,
        lastTargetId: withResult.currentOpponentIdRaw,
      ),
    );
  }

  GameCombatState _reduceFlightAttemptResult(
    GameCombatState previous,
    FlightAttemptResultEvent event,
  ) {
    final nextAttempts = event.isSuccess
        ? previous.flightAttemptsLeft
        : (previous.flightAttemptsLeft > 0 ? previous.flightAttemptsLeft - 1 : 0);
    return previous.when(
      idle: (s) => s,
      active: (active) => active.copyWith(
        flightAttemptsLeft: nextAttempts,
        lastFlightAttemptSuccess: Option.of(event.isSuccess),
      ),
      withResult: (withResult) =>
          withResult.copyWith(
            flightAttemptsLeft: nextAttempts,
            lastFlightAttemptSuccess: Option.of(event.isSuccess),
          ),
    );
  }

  GameCombatState _reduceCombatCountdown(
    GameCombatState previous,
    CombatCountdownEvent event,
  ) {
    return previous.when(
      idle: (s) => s,
      active: (active) => active.copyWith(combatCountdown: event.seconds),
      withResult: (withResult) =>
          withResult.copyWith(combatCountdown: event.seconds),
    );
  }

  GameCombatState _reduceCombatResultsCleared(
    GameCombatState previous,
    CombatResultsClearedEvent event,
  ) {
    if (previous is! CombatWithResult) return previous;
    return CombatActive(
      combatRoomId: previous.combatRoomIdRaw,
      attackerId: previous.attackerIdRaw,
      defenderId: previous.defenderIdRaw,
      currentPlayerId: previous.currentPlayerIdRaw,
      currentOpponentId: previous.currentOpponentIdRaw,
      combatCountdown: previous.combatCountdown,
      flightAttemptsLeft: previous.flightAttemptsLeft,
      lastFlightAttemptSuccess: previous.lastFlightAttemptSuccess,
    );
  }

  GameCombatState _reduceFlightAttemptFeedbackCleared(
    GameCombatState previous,
    FlightAttemptFeedbackClearedEvent event,
  ) {
    return previous.when(
      idle: (s) => s,
      active: (active) =>
          active.copyWith(lastFlightAttemptSuccess: const Option.none()),
      withResult: (withResult) =>
          withResult.copyWith(lastFlightAttemptSuccess: const Option.none()),
    );
  }
}
