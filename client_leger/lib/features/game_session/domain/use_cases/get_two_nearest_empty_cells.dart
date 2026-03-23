import '../models/game_board_position.dart';
import '../state/game_board_state.dart';

List<GameBoardPosition> getTwoNearestEmptyCells(
  Board board,
  GameBoardPosition origin,
  GameBoardState boardState,
) {
  final emptyCells = <GameBoardPosition>[];
  final visited = <String>{};
  final queue = <({int x, int y, int distance})>[];
  queue.add((x: origin.x, y: origin.y, distance: 0));
  visited.add('${origin.x}-${origin.y}');
  const directions = [
    (0, -1),
    (0, 1),
    (-1, 0),
    (1, 0),
    (-1, -1),
    (1, -1),
    (-1, 1),
    (1, 1),
  ];
  while (queue.isNotEmpty && emptyCells.length < 2) {
    final current = queue.removeAt(0);
    if (current.distance > 0) {
      final cell = board.matrix[current.x][current.y];
      final pos = GameBoardPosition(x: current.x, y: current.y);
      if (cell.isEmpty(boardState)) {
        emptyCells.add(pos);
      }
    }
    for (final (dx, dy) in directions) {
      final newX = current.x + dx;
      final newY = current.y + dy;
      final key = '$newX-$newY';
      if (board.isInBounds(newX, newY) && !visited.contains(key)) {
        visited.add(key);
        queue.add((x: newX, y: newY, distance: current.distance + 1));
      }
    }
  }
  return emptyCells;
}
