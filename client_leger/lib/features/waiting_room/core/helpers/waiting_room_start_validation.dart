import '../../../game_session/core/constants/game_rules_constants.dart';
import '../../../game_session/core/enums/board_size.dart';
import '../../domain/models/waiting_room_model.dart';
import '../typedefs/waiting_room_start_validation_params.dart';

bool isWaitingRoomStartValid(
  WaitingRoomModel room,
  WaitingRoomStartValidationParams params,
) {
  final playerCount = room.players.length;
  if (!room.isLocked || playerCount <= 1) return false;
  if (params.boardSize != null) {
    final boardSize = BoardSize.fromInt(params.boardSize!);
    final limits = GameRulesConstants.sizeLimits[boardSize]!;
    if (playerCount < limits.min || playerCount > limits.max) return false;
  }
  if ((params.isCTF ?? false) && playerCount % 2 != 0) return false;
  return true;
}

bool shouldBlockLockByPlayerLimit(
  WaitingRoomModel room,
  WaitingRoomStartValidationParams params,
) {
  if (room.isLocked || params.boardSize == null) return false;
  final limits =
      GameRulesConstants.sizeLimits[BoardSize.fromInt(params.boardSize!)]!;
  return room.players.length >= limits.max;
}

bool isWaitingRoomAtMaxPlayers(
  WaitingRoomModel room,
  WaitingRoomStartValidationParams params,
) {
  if (params.boardSize == null) return false;
  final limits =
      GameRulesConstants.sizeLimits[BoardSize.fromInt(params.boardSize!)]!;
  return room.players.length >= limits.max;
}
