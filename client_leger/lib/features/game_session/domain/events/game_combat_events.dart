import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_combat_events.freezed.dart';

@freezed
class AttackResultEvent with _$AttackResultEvent {
  const factory AttackResultEvent({
    required bool isAttackSuccess,
    required int opponentHealthPoints,
    required int attackValue,
    required int defenseValue,
  }) = _AttackResultEvent;
}

@freezed
class FlightAttemptResultEvent with _$FlightAttemptResultEvent {
  const factory FlightAttemptResultEvent({
    required bool isSuccess,
    required int attackerEvasionPoints,
  }) = _FlightAttemptResultEvent;
}

@freezed
class CombatTurnStartedEvent with _$CombatTurnStartedEvent {
  const factory CombatTurnStartedEvent({
    required String combatRoomId,
    required String currentPlayerId,
    required String currentOpponentId,
    required String attackerId,
    required String defenderId,
  }) = _CombatTurnStartedEvent;
}

@freezed
class EndCombatResultEvent with _$EndCombatResultEvent {
  const factory EndCombatResultEvent({
    required String winnerId,
    required String loserId,
    required bool isByFlight,
  }) = _EndCombatResultEvent;
}

@freezed
class CombatCountdownEvent with _$CombatCountdownEvent {
  const factory CombatCountdownEvent({required int seconds}) =
      _CombatCountdownEvent;
}

@freezed
class CombatResultsClearedEvent with _$CombatResultsClearedEvent {
  const factory CombatResultsClearedEvent() = _CombatResultsClearedEvent;
}

@freezed
class FlightAttemptFeedbackClearedEvent
    with _$FlightAttemptFeedbackClearedEvent {
  const factory FlightAttemptFeedbackClearedEvent() =
      _FlightAttemptFeedbackClearedEvent;
}
