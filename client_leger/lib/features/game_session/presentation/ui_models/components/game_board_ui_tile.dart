import 'package:fpdart/fpdart.dart';

import '../../../core/constants/tile_assets.dart';
import '../../../core/enums/tile_orientation.dart';
import '../../../core/enums/tile_type.dart';
import '../../../domain/models/tile.dart';

class GameBoardUiTile {
  final Tile sourceTile;
  final TileType displayType;
  final Option<TileOrientation> orientation;
  final Option<TileState> doorState;
  final Option<String> diagonalSuffix;
  final int? cellX;
  final int? cellY;

  const GameBoardUiTile({
    required this.sourceTile,
    required this.displayType,
    required this.orientation,
    required this.doorState,
    required this.diagonalSuffix,
    this.cellX,
    this.cellY,
  });

  String get imagePath {
    return switch (sourceTile) {
      TrapTile() => TileAssets.imagePathFor(sourceTile),
      TeleportPadTile() => TileAssets.imagePathFor(sourceTile),
      _ => TileAssets.tileImagePath(
          displayType,
          doorState.fold(() => null, (s) => s),
          orientation.fold(() => null, (o) => o),
          diagonalSuffix.fold(() => null, (s) => s),
          cellX,
          cellY,
        ),
    };
  }

  String get imagePathBase {
    return switch (sourceTile) {
      TrapTile() => TileAssets.imagePathFor(sourceTile),
      TeleportPadTile() => TileAssets.imagePathFor(sourceTile),
      _ => TileAssets.tileImagePath(
          displayType,
          doorState.fold(() => null, (s) => s),
          orientation.fold(() => null, (o) => o),
        ),
    };
  }
}
