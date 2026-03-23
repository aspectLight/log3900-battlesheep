import 'package:fpdart/fpdart.dart';

import '../../../../core/helpers/map_utils.dart';
import 'autotile_mapper.dart';
import '../../domain/models/game_board_position.dart';
import '../../core/enums/tile_orientation.dart';
import '../../core/enums/tile_type.dart';
import '../../domain/state/game_board_state.dart';
import '../../domain/state/game_player_state.dart';
import '../ui_models/components/game_board_cell_ui.dart';
import '../ui_models/components/game_board_position_ui.dart';
import '../ui_models/components/game_board_ui.dart';
import '../ui_models/components/game_board_ui_character.dart';
import '../ui_models/components/game_board_ui_item.dart';

GameBoardCellUi toGameBoardCellUi(
  BoardCell cell,
  GamePlayerState playerState,
  GameBoardState boardState,
  Map<GameBoardPosition, String> positionToPlayerId, {
  required Option<TileOrientation> resolvedOrientation,
  required Option<TileType> displayTileType,
  required Option<String> diagonalSuffix,
}) {
  final character = Option.fromNullable(positionToPlayerId[cell.position])
      .flatMap((id) => playerState.findById(id))
      .map(_toGameBoardUiCharacter);
  final cellItem = boardState.items[cell.position];
  final item = Option.fromNullable(cellItem).map((i) => GameBoardUiItem(type: i.type));
  return GameBoardCellUi(
    tile: cell.tile,
    positionUi: GameBoardPositionUi(x: cell.x, y: cell.y),
    tileOrientation: resolvedOrientation,
    displayTileType: displayTileType,
    diagonalSuffix: diagonalSuffix,
    item: item,
    character: character,
    hasPathUp: cell.hasPathUp,
    hasPathDown: cell.hasPathDown,
    hasPathLeft: cell.hasPathLeft,
    hasPathRight: cell.hasPathRight,
  );
}

GameBoardUi toGameBoardUi(
  Board board,
  GamePlayerState playerState,
  GameBoardState boardState,
) {
  final positionToPlayerId = invertMap(boardState.playerPositions);
  final matrix = <List<GameBoardCellUi>>[];
  for (var i = 0; i < board.size; i++) {
    final row = <GameBoardCellUi>[];
    for (var j = 0; j < board.size; j++) {
      final cell = board.matrix[i][j];
      final autotile = autotileResultForCell(board, i, j, cell.tile.type);
      final hasPersistedOrientation = cell.tileOrientation != null;
      final resolvedOrientation = hasPersistedOrientation
          ? Option.of(cell.tileOrientation!)
          : autotile.map((r) => r.orientation);
      final displayTileType = hasPersistedOrientation
          ? const Option<TileType>.none()
          : autotile.flatMap((r) => r.displayType);
      final diagonalSuffix = hasPersistedOrientation
          ? const Option<String>.none()
          : autotile.flatMap((r) => r.diagonalSuffix);
      row.add(
        toGameBoardCellUi(
          cell,
          playerState,
          boardState,
          positionToPlayerId,
          resolvedOrientation: resolvedOrientation,
          displayTileType: displayTileType,
          diagonalSuffix: diagonalSuffix,
        ),
      );
    }
    matrix.add(row);
  }
  return GameBoardUi(size: board.size, matrix: matrix);
}

GameBoardUiCharacter _toGameBoardUiCharacter(GamePlayer character) {
  return GameBoardUiCharacter(
    id: character.id,
    name: character.name,
    characterType: character.characterType,
    color: character.color,
    orientation: character.orientation,
    state: character.state,
  );
}
