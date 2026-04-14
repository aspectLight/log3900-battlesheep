import '../../../domain/commands/game_movement_commands.dart';
import '../../../domain/events/game_movement_events.dart';
import 'game_board_position_dto_extensions.dart';
import '../dto/game_player_movement_dto.dart';

extension PlayerGetMovementsCommandToDto on PlayerGetMovementsCommand {
  PlayerGetMovementsCommandDto toDto() =>
      PlayerGetMovementsCommandDto(roomId: roomId, hasBoots: hasBoots);
}

extension PlayerMovedCommandToDto on PlayerMovedCommand {
  PlayerMovedCommandDto toDto() => PlayerMovedCommandDto(
    roomId: roomId,
    playerId: playerId,
    selectedPath: selectedPath.map((p) => p.toDto()).toList(),
  );
}

extension PlayerTeleportedCommandToDto on PlayerTeleportedCommand {
  PlayerTeleportedCommandDto toDto() => PlayerTeleportedCommandDto(
    roomId: roomId,
    playerId: playerId,
    destination: destination.toDto(),
    hasCamouflage: hasCamouflage,
  );
}

extension SynchronizeMovementCommandToDto on SynchronizeMovementCommand {
  SynchronizeMovementCommandDto toDto() => SynchronizeMovementCommandDto(
    roomId: roomId,
    playerId: playerId,
    destination: destination.toDto(),
  );
}

extension PlayerMovedDtoToEntity on PlayerMovedDto {
  PlayerMovedEvent toEntity() => PlayerMovedEvent(
    playerId: playerId,
    movementPoints: movementPoints,
    selectedPath: selectedPath.map((p) => p.toEntity()).toList(),
  );
}

extension PlayerTeleportedDtoToEntity on PlayerTeleportedDto {
  PlayerTeleportedEvent toEntity() => PlayerTeleportedEvent(
    playerId: playerId,
    destination: destination.toEntity(),
  );
}

extension VirtualPlayerMovedDtoToEntity on VirtualPlayerMovedDto {
  VirtualPlayerMovedEvent toEntity() => VirtualPlayerMovedEvent(
    playerId: playerId,
    path: path.map((p) => p.toEntity()).toList(),
    remainingMovementPoints: remainingMovementPoints,
    opponentPlayerId: opponentPlayerId ?? '',
  );
}

extension SynchronizeMovementDtoToEntity on SynchronizeMovementDto {
  SynchronizeMovementEvent toEntity() => SynchronizeMovementEvent(
    playerId: playerId,
    destination: destination.toEntity(),
  );
}

extension ReachablePathsResponseDtoToEntity on ReachablePathsResponseDto {
  ReachablePathsResponseEvent toEntity() => ReachablePathsResponseEvent(
    paths: paths
        .map(
          (e) => ReachablePath(
            from: e.$1.toEntity(),
            path: e.$2.map((p) => p.toEntity()).toList(),
          ),
        )
        .toList(),
  );
}
