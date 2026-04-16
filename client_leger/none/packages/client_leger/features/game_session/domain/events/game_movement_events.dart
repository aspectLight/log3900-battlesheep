import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/enums/board_character.dart';
import '../models/game_board_position.dart';

part 'game_movement_events.freezed.dart';

@freezed
class PlayerMovedEvent with _$PlayerMovedEvent {
  const factory PlayerMovedEvent({
    required String playerId,
    required int movementPoints,
    required List<GameBoardPosition> selectedPath,
  }) = _PlayerMovedEvent;
}

@freezed
class PlayerTeleportedEvent with _$PlayerTeleportedEvent {
  const factory PlayerTeleportedEvent({
    required String playerId,
    required GameBoardPosition destination,
  }) = _PlayerTeleportedEvent;
}

@freezed
class VirtualPlayerMovedEvent with _$VirtualPlayerMovedEvent {
  const factory VirtualPlayerMovedEvent({
    required String playerId,
    required List<GameBoardPosition> path,
    required int remainingMovementPoints,
    @Default('') String opponentPlayerId,
  }) = _VirtualPlayerMovedEvent;
}

@freezed
class SynchronizeMovementEvent with _$SynchronizeMovementEvent {
  const factory SynchronizeMovementEvent({
    required String playerId,
    required GameBoardPosition destination,
  }) = _SynchronizeMovementEvent;
}

@freezed
class ReachablePath with _$ReachablePath {
  const factory ReachablePath({
    required GameBoardPosition from,
    required List<GameBoardPosition> path,
  }) = _ReachablePath;
}

@freezed
class ReachablePathsResponseEvent with _$ReachablePathsResponseEvent {
  const factory ReachablePathsResponseEvent({
    required List<ReachablePath> paths,
  }) = _ReachablePathsResponseEvent;
}

@freezed
class PlayerMovementStepEvent with _$PlayerMovementStepEvent {
  const factory PlayerMovementStepEvent({
    required String playerId,
    required GameBoardPosition destination,
    required BoardCharacterOrientation orientation,
  }) = _PlayerMovementStepEvent;
}

@freezed
class PlayerIdleResetEvent with _$PlayerIdleResetEvent {
  const factory PlayerIdleResetEvent({required String playerId}) =
      _PlayerIdleResetEvent;
}
