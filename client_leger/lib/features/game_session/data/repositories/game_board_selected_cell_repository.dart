import 'package:signals_flutter/signals_flutter.dart';

import '../../domain/models/game_board_cell_selection.dart';
import '../../domain/models/game_board_position.dart';

class GameBoardSelectedCellRepository {
  final Signal<GameBoardCellSelection> state = signal<GameBoardCellSelection>(
    GameBoardCellUnselected(),
  );

  void setSelectedCell(int x, int y) {
    state.value = GameBoardCellSelected(GameBoardPosition(x: x, y: y));
  }

  void clearSelection() {
    state.value = GameBoardCellUnselected();
  }
}
