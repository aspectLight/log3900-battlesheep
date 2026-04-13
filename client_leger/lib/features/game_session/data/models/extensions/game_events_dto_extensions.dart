import '../../../domain/commands/game_door_commands.dart';
import '../../../domain/events/game_events.dart';
import '../../../core/constants/game_rules_constants.dart';
import '../dto/game_events_dto.dart';
import 'game_board_position_dto_extensions.dart';
import 'game_item_dto_extensions.dart';

extension ToggleDoorCommandToDto on ToggleDoorCommand {
  ToggleDoorCommandDto toDto() =>
      ToggleDoorCommandDto(roomId: roomId, x: x, y: y);
}

extension DoorToggledDtoToEntity on DoorToggledDto {
  DoorToggledEvent toEntity() => DoorToggledEvent(x: x, y: y);
}

extension SpawnedPlayerDtoToEntity on SpawnedPlayerDto {
  SpawnedPlayerEvent toEntity() => SpawnedPlayerEvent(
        id: id,
        name: name,
        characterType: characterType,
        color: color,
        movementPoints: movementPoints,
        actionPoints: actionPoints,
        spawnPoint: spawnPoint.toEntity(),
        currentBoardPosition:
            (boardPosition ?? spawnPoint).toEntity(),
        inventory: inventory.map((d) => d.toEntity()).toList(),
        stats: stats,
        diceChoice: diceChoice,
        isVirtual: isVirtual,
        team: team,
      );
}

extension PlayerSpawnedPayloadOnMap on Map<String, dynamic> {
  SpawnedPlayerDto toSpawnedPlayerDto() =>
      SpawnedPlayerDto.fromPlayerSpawnedPayload(this);
}

extension PlayerSpawnedPayloadOnList on List<dynamic> {
  PlayerSpawnedDto toPlayerSpawnedDto() => PlayerSpawnedDto(
        players: whereType<Map<String, dynamic>>().map((e) => e.toSpawnedPlayerDto()).toList(),
      );
}

extension PlayerSpawnedDtoToEntity on PlayerSpawnedDto {
  PlayerSpawnedEvent toEntity() =>
      PlayerSpawnedEvent(players: players.map((d) => d.toEntity()).toList());
}

extension TurnStartingDtoToEntity on TurnStartingDto {
  TurnStartingEvent toEntity() => TurnStartingEvent(
        nextPlayerId: nextPlayerId,
        startTime: startTime,
        nextPlayerMovementPoints: nextPlayerMovementPoints,
        nextPlayerActionPoints:
            nextPlayerActionPoints ?? GameRulesConstants.actionPointsPerTurn,
        isNextPlayerVirtual: isNextPlayerVirtual,
      );
}

extension UpdateCountdownDtoToEntity on UpdateCountdownDto {
  UpdateCountdownEvent toEntity() => UpdateCountdownEvent(countdown: countdown);
}

extension UpdateStartingCountdownDtoToEntity on UpdateStartingCountdownDto {
  UpdateStartingCountdownEvent toEntity() =>
      UpdateStartingCountdownEvent(countdown: countdown);
}

extension UpdateScoreDtoToEntity on UpdateScoreDto {
  UpdateScoreEvent toEntity() => UpdateScoreEvent(winnerId: winnerId);
}

extension FinishGameDtoToEntity on FinishGameDto {
  FinishGameEvent toEntity() => FinishGameEvent(winnerId: winnerId);
}

extension GameCanceledDtoToEntity on GameCanceledDto {
  GameCanceledEvent toEntity() => GameCanceledEvent(playerId: playerId);
}

extension GameAbandonedDtoToEntity on GameAbandonedDto {
  GameAbandonedEvent toEntity() => const GameAbandonedEvent();
}

extension PlayerAbandonedDtoToEntity on PlayerAbandonedDto {
  PlayerAbandonedEvent toEntity() =>
      PlayerAbandonedEvent(playerId: playerId);
}

extension OrganizatorChangedDtoToEntity on OrganizatorChangedDto {
  OrganizatorChangedEvent toEntity() =>
      OrganizatorChangedEvent(newHostId: newHostId);
}
