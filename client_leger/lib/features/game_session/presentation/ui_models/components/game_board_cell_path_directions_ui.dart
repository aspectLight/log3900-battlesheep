import '../../../domain/models/game_board_cell_path_directions.dart';

class GameBoardCellPathDirectionsUi {
  final bool up;
  final bool down;
  final bool left;
  final bool right;

  const GameBoardCellPathDirectionsUi({
    required this.up,
    required this.down,
    required this.left,
    required this.right,
  });

  factory GameBoardCellPathDirectionsUi.fromCellPathDirections(
    GameBoardCellPathDirections directions,
  ) {
    return GameBoardCellPathDirectionsUi(
      up: directions.up,
      down: directions.down,
      left: directions.left,
      right: directions.right,
    );
  }
}
