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
    if (event is CombatEndOverlayClearedEvent) {
      return _reduceCombatEndOverlayCleared(previous, event);
    }
    return previous;
  }

  GameCombatState _reduceCombatTurnStarted(
    GameCombatState previous,
    CombatTurnStartedEvent event,
  ) {
    // Keep showing attack/defense dice until [CombatResultsClearedEvent] fires.
    // Replacing with plain [CombatActive] here made results vanish immediately when
    // the server emitted combatTurnStarted right after attackResult (common timing).
    if (previous is CombatWithResult) {
      return previous.copyWith(
        combatRoomId: event.combatRoomId,
        attackerId: event.attackerId,
        defenderId: event.defenderId,
        currentPlayerId: event.currentPlayerId,
        currentOpponentId: event.currentOpponentId,
      );
    }
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
    return previous.when(
      idle: (s) => s,
      active: (active) => CombatResolved(
        combatRoomId: active.combatRoomIdRaw,
        attackerId: active.attackerIdRaw,
        defenderId: active.defenderIdRaw,
        currentPlayerId: active.currentPlayerIdRaw,
        currentOpponentId: active.currentOpponentIdRaw,
        combatCountdown: active.combatCountdown,
        // Angular action-socket: on endCombat + isByFlight, flightAttemptsLeft = 2 before reset.
        flightAttemptsLeft: event.isByFlight ? 2 : active.flightAttemptsLeft,
        winnerId: event.winnerId,
        loserId: event.loserId,
        isByFlight: event.isByFlight,
      ),
      withResult: (withResult) => CombatResolved(
        combatRoomId: withResult.combatRoomIdRaw,
        attackerId: withResult.attackerIdRaw,
        defenderId: withResult.defenderIdRaw,
        currentPlayerId: withResult.currentPlayerIdRaw,
        currentOpponentId: withResult.currentOpponentIdRaw,
        combatCountdown: withResult.combatCountdown,
        flightAttemptsLeft: event.isByFlight ? 2 : withResult.flightAttemptsLeft,
        winnerId: event.winnerId,
        loserId: event.loserId,
        isByFlight: event.isByFlight,
      ),
      resolved: (s) => s,
    );
  }

  GameCombatState _reduceAttackResult(
    GameCombatState previous,
    AttackResultEvent event,
  ) {
    return previous.when(
      idle: (s) => s,
      resolved: (s) => s,
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
        : (previous.flightAttemptsLeft > 0
              ? previous.flightAttemptsLeft - 1
              : 0);
    return previous.when(
      idle: (s) => s,
      resolved: (s) => s,
      active: (active) => active.copyWith(
        flightAttemptsLeft: nextAttempts,
        lastFlightAttemptSuccess: Option.of(event.isSuccess),
      ),
      withResult: (withResult) => withResult.copyWith(
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
      resolved: (r) => CombatResolved(
        combatRoomId: r.combatRoomIdRaw,
        attackerId: r.attackerIdRaw,
        defenderId: r.defenderIdRaw,
        currentPlayerId: r.currentPlayerIdRaw,
        currentOpponentId: r.currentOpponentIdRaw,
        combatCountdown: event.seconds,
        flightAttemptsLeft: r.flightAttemptsLeft,
        winnerId: r.winnerId,
        loserId: r.loserId,
        isByFlight: r.isByFlight,
      ),
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
      resolved: (s) => s,
      active: (active) =>
          active.copyWith(lastFlightAttemptSuccess: const Option.none()),
      withResult: (withResult) =>
          withResult.copyWith(lastFlightAttemptSuccess: const Option.none()),
    );
  }

  GameCombatState _reduceCombatEndOverlayCleared(
    GameCombatState previous,
    CombatEndOverlayClearedEvent event,
  ) {
    if (previous is! CombatResolved) return previous;
    return CombatIdle(combatCountdown: previous.combatCountdown);
  }
}
