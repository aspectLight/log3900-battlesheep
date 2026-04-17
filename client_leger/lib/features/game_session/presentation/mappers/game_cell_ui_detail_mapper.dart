import 'package:fpdart/fpdart.dart';

import '../../../../core/helpers/functional_programming.dart';
import '../../../../core/helpers/map_utils.dart';
import '../../core/enums/tile_type.dart';
import 'autotile_mapper.dart';
import '../../core/definitions/item_definition.dart';
import '../../core/definitions/tile_definition.dart';
import '../../domain/models/game_board_cell_selection.dart';
import '../../domain/state/game_board_state.dart';
import '../../domain/state/game_player_state.dart';
import '../ui_models/components/game_board_cell_ui.dart';
import '../ui_models/widget_states/game_cell_detail_ui_state.dart';
import 'game_board_cell_ui_mapper.dart';

GameCellDetailUiState selectionToCellDetail(
  GameBoardCellSelection selection,
  Board board,
  String currentPlayerId,
  GamePlayerState playerState,
  GameBoardState boardState,
) {
  return switch (selection) {
    GameBoardCellUnselected() => const GameCellDetailEmpty(),
    GameBoardCellSelected(:final position) => position.when(
      none: () => const GameCellDetailEmpty(),
      some: (pos) => _selectedToDetail(
        board,
        pos.x,
        pos.y,
        currentPlayerId,
        playerState,
        boardState,
      ),
    ),
  };
}

GameCellDetailUiState _selectedToDetail(
  Board board,
  int x,
  int y,
  String currentPlayerId,
  GamePlayerState playerState,
  GameBoardState boardState,
) {
  if (!board.isInBounds(x, y)) {
    return const GameCellDetailEmpty();
  }
  final positionToPlayerId = invertMap(boardState.playerPositions);
  final rawCell = board.matrix[x][y];
  final autotile = autotileResultForCell(board, x, y, rawCell.tile.type);
  final hasPersistedOrientation = rawCell.tileOrientation != null;
  final resolvedOrientation = hasPersistedOrientation
      ? Option.of(rawCell.tileOrientation!)
      : autotile.map((r) => r.orientation);
  final displayTileType = hasPersistedOrientation
      ? const Option<TileType>.none()
      : autotile.flatMap((r) => r.displayType);
  final diagonalSuffix = hasPersistedOrientation
      ? const Option<String>.none()
      : autotile.flatMap((r) => r.diagonalSuffix);
  final cell = toGameBoardCellUi(
    rawCell,
    playerState,
    boardState,
    positionToPlayerId,
    resolvedOrientation: resolvedOrientation,
    displayTileType: displayTileType,
    diagonalSuffix: diagonalSuffix,
  );
  return toGameCellDetailUiState(cell, currentPlayerId);
}

GameCellDetailUiState toGameCellDetailUiState(
  GameBoardCellUi cell,
  String currentPlayerId,
) {
  final byCharacter = cell.character.fold<GameCellDetailUiState?>(() => null, (
    c,
  ) {
    final isCurrentPlayer = c.id == currentPlayerId;
    return GameCellDetailPlayer(
      GameCellDetailPlayerInfo(
        name: c.name,
        avatarPath: Option.of(c.avatarFullPath),
        avatarFullPath: const Option.none(),
        isCurrentPlayer: isCurrentPlayer,
      ),
    );
  });
  if (byCharacter != null) return byCharacter;
  final byItem = cell.item.fold<GameCellDetailUiState?>(() => null, (itemUi) {
    final def = ItemDefinition.fromType(itemUi.type);
    return Option.fromNullable(
      def,
    ).fold(() => const GameCellDetailEmpty(), GameCellDetailItem.new);
  });
  if (byItem != null) return byItem;
  final tileDef = TileDefinition.fromTile(cell.tile);
  return GameCellDetailTile(tileDef);
}
