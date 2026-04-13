import '../../../domain/commands/game_movement_commands.dart';
import '../../../domain/events/game_environment_events.dart';
import '../dto/game_trap_torch_dto.dart';

extension TrapPendingDtoToEntity on TrapPendingDto {
  TrapPendingEvent toEntity() => TrapPendingEvent(
        roomId: roomId,
        playerId: playerId,
        canAvoid: canAvoid,
      );
}

extension TrapResultDtoToEntity on TrapResultDto {
  TrapResultSyncEvent toEntity() => TrapResultSyncEvent(
        playerId: playerId,
        remainingMovementPoints: remainingMovementPoints,
        activated: activated,
      );
}

extension TrapChoiceCommandToDto on TrapChoiceCommand {
  TrapChoiceCommandDto toDto() => TrapChoiceCommandDto(
        roomId: roomId,
        playerId: playerId,
        choice: choice,
      );
}

extension TorchIlluminationUpdateDtoToDomain on TorchIlluminationUpdateDto {
  BoardIlluminationUpdatedEvent toBoardIlluminationEvent() =>
      BoardIlluminationUpdatedEvent(
        illuminatedCellKeys: illuminatedCells.toSet(),
      );

  PlayerTorchStatsSyncEvent toPlayerTorchStatsEvent() {
    final patches = <TorchPlayerStatPatch>[];
    for (final p in players) {
      final stats = p.stats;
      if (stats == null) continue;
      final av = stats.attack?.value;
      final dv = stats.defense?.value;
      if (av == null || dv == null) continue;
      patches.add(
        TorchPlayerStatPatch(
          playerId: p.id,
          attack: av,
          defense: dv,
        ),
      );
    }
    return PlayerTorchStatsSyncEvent(patches: patches);
  }
}
