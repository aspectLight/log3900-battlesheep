import 'package:fpdart/fpdart.dart';

import '../../../core/constants/tile_assets.dart';
import '../../../core/enums/tile_orientation.dart';
import '../../../core/enums/tile_type.dart';

class GameBoardUiTile {
  final TileType displayType;
  final Option<TileOrientation> orientation;
  final Option<TileState> doorState;
  final Option<String> diagonalSuffix;
  final int? cellX;
  final int? cellY;

  const GameBoardUiTile({
    required this.displayType,
    required this.orientation,
    required this.doorState,
    required this.diagonalSuffix,
    this.cellX,
    this.cellY,
  });

  String get imagePath => TileAssets.tileImagePath(
        displayType,
        doorState.fold(() => null, (s) => s),
        orientation.fold(() => null, (o) => o),
        diagonalSuffix.fold(() => null, (s) => s),
        cellX,
        cellY,
      );

  String get imagePathBase => TileAssets.tileImagePath(
        displayType,
        doorState.fold(() => null, (s) => s),
        orientation.fold(() => null, (o) => o),
      );
}
