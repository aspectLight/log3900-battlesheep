import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/game_board_position.dart';

part 'game_movement_commands.freezed.dart';

@freezed
class PlayerGetMovementsCommand with _$PlayerGetMovementsCommand {
  const factory PlayerGetMovementsCommand({
    required String roomId,
    required bool hasBoots,
  }) = _PlayerGetMovementsCommand;
}

@freezed
class PlayerMovedCommand with _$PlayerMovedCommand {
  const factory PlayerMovedCommand({
    required String roomId,
    required String playerId,
    required List<GameBoardPosition> selectedPath,
  }) = _PlayerMovedCommand;
}

@freezed
class PlayerTeleportedCommand with _$PlayerTeleportedCommand {
  const factory PlayerTeleportedCommand({
    required String roomId,
    required String playerId,
    required GameBoardPosition destination,
    required bool hasCamouflage,
  }) = _PlayerTeleportedCommand;
}

@freezed
class SynchronizeMovementCommand with _$SynchronizeMovementCommand {
  const factory SynchronizeMovementCommand({
    required String roomId,
    required String playerId,
    required GameBoardPosition destination,
  }) = _SynchronizeMovementCommand;
}

@freezed
class TrapChoiceCommand with _$TrapChoiceCommand {
  const factory TrapChoiceCommand({
    required String roomId,
    required String playerId,
    required String choice,
  }) = _TrapChoiceCommand;
}
