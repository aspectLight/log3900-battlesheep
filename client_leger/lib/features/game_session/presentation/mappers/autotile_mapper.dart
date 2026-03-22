import 'package:fpdart/fpdart.dart';

import '../../core/constants/autotile_constants.dart';
import '../../core/enums/tile_orientation.dart';
import '../../core/enums/tile_type.dart';
import '../../core/typedefs/autotile_typedefs.dart';
import '../../domain/state/game_board_state.dart';

Option<AutotileResult> autotileResultForCell(
  Board board,
  int x,
  int y,
  TileType type,
) {
  if (type == TileType.ice || type == TileType.water) {
    final mask = _cardinalBitmask(x, y, board, type);
    final map = type == TileType.water
        ? orientationByBitmaskWater
        : orientationByBitmaskIce;
    final orientation = map[mask];
    if (orientation == null) return const Option.none();
    final diag = _diagonalSuffix(x, y, board, type);
    final diagonalSuffix =
        diag.isEmpty ? const Option<String>.none() : Option.of(diag);
    return Option.of((
      displayType: const Option<TileType>.none(),
      orientation: orientation,
      diagonalSuffix: diagonalSuffix,
    ));
  }
  if (_isWallCategory(type)) {
    final mask = _cardinalBitmask(x, y, board, type);
    final entry = wallBitmaskToTypeAndOrientation[mask];
    if (entry == null) return const Option.none();
    return Option.of((
      displayType: Option.of(entry.type),
      orientation: entry.orientation,
      diagonalSuffix: const Option<String>.none(),
    ));
  }
  return const Option.none();
}

Option<TileOrientation> autotileOrientationForCell(
  Board board,
  int x,
  int y,
  TileType type,
) {
  return autotileResultForCell(board, x, y, type).map((r) => r.orientation);
}

int _cardinalBitmask(int x, int y, Board board, TileType type) {
  var mask = 0;
  final size = board.size;
  if (x > 0 &&
      _isSameCategoryForBitmask(type, board.matrix[x - 1][y].tile.type)) {
    mask |= 1;
  }
  if (y < size - 1 &&
      _isSameCategoryForBitmask(type, board.matrix[x][y + 1].tile.type)) {
    mask |= 2;
  }
  if (x < size - 1 &&
      _isSameCategoryForBitmask(type, board.matrix[x + 1][y].tile.type)) {
    mask |= 4;
  }
  if (y > 0 &&
      _isSameCategoryForBitmask(type, board.matrix[x][y - 1].tile.type)) {
    mask |= 8;
  }
  return mask;
}

String _diagonalSuffix(int x, int y, Board board, TileType type) {
  final size = board.size;
  var suffix = '';
  if (x > 0 && y > 0 &&
      _isSameCategoryForBitmask(type, board.matrix[x - 1][y - 1].tile.type) &&
      _isSameCategoryForBitmask(type, board.matrix[x - 1][y].tile.type) &&
      _isSameCategoryForBitmask(type, board.matrix[x][y - 1].tile.type)) {
    suffix += '_TL';
  }
  if (x > 0 && y < size - 1 &&
      _isSameCategoryForBitmask(type, board.matrix[x - 1][y + 1].tile.type) &&
      _isSameCategoryForBitmask(type, board.matrix[x - 1][y].tile.type) &&
      _isSameCategoryForBitmask(type, board.matrix[x][y + 1].tile.type)) {
    suffix += '_TR';
  }
  if (x < size - 1 && y < size - 1 &&
      _isSameCategoryForBitmask(type, board.matrix[x + 1][y + 1].tile.type) &&
      _isSameCategoryForBitmask(type, board.matrix[x + 1][y].tile.type) &&
      _isSameCategoryForBitmask(type, board.matrix[x][y + 1].tile.type)) {
    suffix += '_BR';
  }
  if (x < size - 1 && y > 0 &&
      _isSameCategoryForBitmask(type, board.matrix[x + 1][y - 1].tile.type) &&
      _isSameCategoryForBitmask(type, board.matrix[x + 1][y].tile.type) &&
      _isSameCategoryForBitmask(type, board.matrix[x][y - 1].tile.type)) {
    suffix += '_BL';
  }
  return suffix;
}

bool _isWallCategory(TileType type) {
  return type == TileType.wall ||
      type == TileType.corner ||
      type == TileType.intersection;
}

bool _isSameCategoryForBitmask(TileType cellType, TileType neighbourType) {
  if (cellType == TileType.ice || cellType == TileType.water) {
    return cellType == neighbourType;
  }
  if (_isWallCategory(cellType)) {
    return _isWallCategory(neighbourType) || neighbourType == TileType.door;
  }
  return false;
}
