import 'package:fpdart/fpdart.dart';

import '../../core/enums/board_character.dart';
import '../../domain/models/game_board_cell_path_directions.dart';
import '../../domain/models/game_board_position.dart';

BoardCharacterOrientation orientationFromStep(
  GameBoardPosition from,
  GameBoardPosition to,
) {
  final dx = to.x - from.x;
  final dy = to.y - from.y;
  if (dx > 0) return BoardCharacterOrientation.down;
  if (dx < 0) return BoardCharacterOrientation.up;
  if (dy > 0) return BoardCharacterOrientation.right;
  if (dy < 0) return BoardCharacterOrientation.left;
  return BoardCharacterOrientation.down;
}

BoardCharacterOrientation orientationFromPath(List<GameBoardPosition> path) {
  if (path.length < 2) return BoardCharacterOrientation.down;
  return orientationFromStep(path[path.length - 2], path[path.length - 1]);
}

GameBoardCellPathDirections pathDirectionsForCell(
  int x,
  int y,
  List<GameBoardPosition> path,
) {
  final i = path.indexWhere((p) => p.x == x && p.y == y);
  if (i < 0) {
    return const GameBoardCellPathDirections(
      up: false,
      down: false,
      left: false,
      right: false,
    );
  }
  final Option<GameBoardPosition> previousPosition = i > 0
      ? Option.of(path[i - 1])
      : const Option.none();
  final Option<GameBoardPosition> nextPosition = i < path.length - 1
      ? Option.of(path[i + 1])
      : const Option.none();
  final hasUp =
      previousPosition.fold(
        () => false,
        (GameBoardPosition p) => p.x == x - 1,
      ) ||
      nextPosition.fold(() => false, (GameBoardPosition p) => p.x == x - 1);
  final hasDown =
      previousPosition.fold(
        () => false,
        (GameBoardPosition p) => p.x == x + 1,
      ) ||
      nextPosition.fold(() => false, (GameBoardPosition p) => p.x == x + 1);
  final hasLeft =
      previousPosition.fold(
        () => false,
        (GameBoardPosition p) => p.y == y - 1,
      ) ||
      nextPosition.fold(() => false, (GameBoardPosition p) => p.y == y - 1);
  final hasRight =
      previousPosition.fold(
        () => false,
        (GameBoardPosition p) => p.y == y + 1,
      ) ||
      nextPosition.fold(() => false, (GameBoardPosition p) => p.y == y + 1);
  return GameBoardCellPathDirections(
    up: hasUp,
    down: hasDown,
    left: hasLeft,
    right: hasRight,
  );
}
