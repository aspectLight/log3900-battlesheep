import 'package:fpdart/fpdart.dart';

import '../../../../core/enums/item_type.dart';
import '../../../../core/helpers/map_utils.dart';
import '../../domain/models/game_board_position.dart';
import '../../domain/models/tile.dart';
import '../../domain/state/game_board_state.dart';
import '../../domain/state/game_player_state.dart';
import '../../domain/state/game_session_state.dart';

bool canPlayerMoveOrAct(
  String playerId,
  GamePlayerState playerState,
  GameBoardState boardState,
  GameSessionState metadataState,
) {
  final player = playerState.findById(playerId);
  final currentPlayer = switch (player) {
    Some(value: final p) => p,
    None() => null,
  };
  if (currentPlayer == null) return false;
  if (currentPlayer.movementPoints > 0) return true;
  final hasActiveItem =
      currentPlayer.inventory.any(
        (item) =>
            item != null &&
            (item.type == ItemType.camouflage ||
                item.type == ItemType.airStrike),
      ) ||
      boardState.pendingItemPickup.fold(
        () => false,
        (p) =>
            p.playerId == playerId &&
            (p.item.type == ItemType.camouflage ||
                p.item.type == ItemType.airStrike),
      );
  if (currentPlayer.actionPoints > 0 && hasActiveItem) return true;
  final pos = boardState.playerPositions[playerId];
  if (pos == null) return false;
  final board = boardState.board;
  if (currentPlayer.actionPoints > 0 &&
      board.matrix[pos.x][pos.y].tile is TeleportPadTile) {
    return true;
  }
  final positionToPlayerId = invertMap(boardState.playerPositions);
  const directions = [(0, 1), (0, -1), (1, 0), (-1, 0)];
  for (final (dx, dy) in directions) {
    final nx = pos.x + dx;
    final ny = pos.y + dy;
    if (!board.isInBounds(nx, ny)) continue;
    final cell = board.matrix[nx][ny];
    final adjPos = GameBoardPosition(x: nx, y: ny);
    final otherPlayerId = positionToPlayerId[adjPos];
    if (otherPlayerId != null && otherPlayerId != playerId) {
      final other = playerState.findById(otherPlayerId);
      if (other case Some(value: final o)) {
        final isCTF =
            metadataState is GameSessionActive && metadataState.isCTF;
        if (!isCTF || o.team != currentPlayer.team) return true;
      }
    }
    if (cell.tile is DoorTile && currentPlayer.actionPoints > 0) return true;
  }
  return false;
}
