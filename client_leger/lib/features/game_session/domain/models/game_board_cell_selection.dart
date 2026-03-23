import 'package:fpdart/fpdart.dart';

import 'game_board_position.dart';

sealed class GameBoardCellSelection {
  Option<GameBoardPosition> get position;
}

final class GameBoardCellUnselected extends GameBoardCellSelection {
  @override
  Option<GameBoardPosition> get position => const Option.none();
}

final class GameBoardCellSelected extends GameBoardCellSelection {
  final GameBoardPosition _position;

  GameBoardCellSelected(this._position);

  @override
  Option<GameBoardPosition> get position => Option.of(_position);
}
