import '../../../domain/commands/game_combat_commands.dart';
import '../../../domain/events/game_combat_events.dart';
import '../dto/game_combat_dto.dart';

extension StartCombatCommandToDto on StartCombatCommand {
  StartCombatCommandDto toDto() =>
      StartCombatCommandDto(roomId: roomId, opponentId: opponentId);
}

extension StartVirtualCombatCommandToDto on StartVirtualCombatCommand {
  StartVirtualCombatCommandDto toDto() => StartVirtualCombatCommandDto(
    roomId: roomId,
    playerId: playerId,
    opponentId: opponentId,
  );
}

extension AttackCommandToDto on AttackCommand {
  AttackCommandDto toDto() => AttackCommandDto(roomId: roomId);
}

extension FlightAttemptCommandToDto on FlightAttemptCommand {
  FlightAttemptCommandDto toDto() => FlightAttemptCommandDto(roomId: roomId);
}

extension AttackResultDtoToEntity on AttackResultDto {
  AttackResultEvent toEntity() => AttackResultEvent(
    isAttackSuccess: isAttackSuccess,
    opponentHealthPoints: opponentHealthPoints,
    attackValue: attackValue,
    defenseValue: defenseValue,
  );
}

extension FlightAttemptResultDtoToEntity on FlightAttemptResultDto {
  FlightAttemptResultEvent toEntity() => FlightAttemptResultEvent(
    isSuccess: isSuccess,
    attackerEvasionPoints: attackerEvasionPoints,
  );
}

extension CombatTurnStartedDtoToEntity on CombatTurnStartedDto {
  CombatTurnStartedEvent toEntity() => CombatTurnStartedEvent(
    combatRoomId: combatRoomId,
    currentPlayerId: currentPlayerId,
    currentOpponentId: currentOpponentId,
    attackerId: attackerId,
    defenderId: defenderId,
  );
}

extension EndCombatResultDtoToEntity on EndCombatResultDto {
  EndCombatResultEvent toEntity() => EndCombatResultEvent(
    winnerId: winnerId,
    loserId: loserId,
    isByFlight: isByFlight,
  );
}
