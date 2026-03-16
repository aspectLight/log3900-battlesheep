import '../../../../../core/converters/game_mode_converter.dart';
import '../../../domain/models/game.dart';
import '../../../domain/models/game_board_position.dart';
import '../../../domain/models/game_item.dart';
import '../../../domain/models/tile.dart';
import '../../../domain/state/game_board_state.dart';
import '../dto/game_dto.dart';

extension GameDtoToEntity on GameDto {
  Game toEntity() {
    final Map<GameBoardPosition, GameItem> items = {};
    final List<List<BoardCell>> matrix = [];
    for (var i = 0; i < board.size; i++) {
      final List<BoardCell> row = [];
      for (var j = 0; j < board.size; j++) {
        final cellDto = board.matrix[i][j];
        final pos = GameBoardPosition(x: i, y: j);
        row.add(
          BoardCell(
            tile: Tile.fromType(cellDto.tileType, cellDto.tileState),
            position: pos,
            tileOrientation: cellDto.tileData.orientation,
          ),
        );
        final cellItemType = cellDto.itemType;
        if (cellItemType != null) {
          items[pos] = GameItem(type: cellItemType);
        }
      }
      matrix.add(row);
    }
    return Game(
      id: id,
      name: name,
      description: description,
      mode: const GameModeConverter().fromJson(mode),
      board: Board(matrix: matrix, size: board.size),
      initialItems: items,
      isVisible: isVisible,
      modificationDate: modificationDate,
    );
  }
}
