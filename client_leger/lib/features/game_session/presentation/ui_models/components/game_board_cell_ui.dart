import 'package:fpdart/fpdart.dart';

import '../../../domain/models/tile.dart';
import '../../../core/enums/tile_orientation.dart';
import '../../../core/enums/tile_type.dart';
import 'game_board_position_ui.dart';
import 'game_board_ui_character.dart';
import 'game_board_ui_item.dart';

class GameBoardCellUi {
  final Tile tile;
  final GameBoardPositionUi positionUi;
  final Option<TileOrientation> tileOrientation;
  final Option<TileType> displayTileType;
  final Option<String> diagonalSuffix;
  final Option<GameBoardUiItem> item;
  final Option<GameBoardUiCharacter> character;
  final bool hasPathUp;
  final bool hasPathDown;
  final bool hasPathLeft;
  final bool hasPathRight;

  const GameBoardCellUi({
    required this.tile,
    required this.positionUi,
    required this.tileOrientation,
    required this.displayTileType,
    required this.diagonalSuffix,
    required this.item,
    required this.character,
    this.hasPathUp = false,
    this.hasPathDown = false,
    this.hasPathLeft = false,
    this.hasPathRight = false,
  });

  int get x => positionUi.x;
  int get y => positionUi.y;
}
