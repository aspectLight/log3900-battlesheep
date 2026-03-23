import 'package:fpdart/fpdart.dart';

import 'game_board_cell_path_directions_ui.dart';

class GameBoardUiCellInteraction {
  final bool isSelected;
  final bool isSelectionModeActive;
  final bool isActionModeActive;
  final bool isReachable;
  final bool isOnMovementPath;
  final Option<GameBoardCellPathDirectionsUi> pathDirections;

  const GameBoardUiCellInteraction({
    required this.isSelected,
    required this.isSelectionModeActive,
    required this.isActionModeActive,
    required this.isReachable,
    required this.isOnMovementPath,
    required this.pathDirections,
  });
}
