import '../enums/tile_orientation.dart';
import '../enums/tile_type.dart';
import '../typedefs/autotile_typedefs.dart';

const BitmaskToTypeAndOrientation wallBitmaskToTypeAndOrientation = {
  0: (type: TileType.wall, orientation: TileOrientation.horizontal),
  1: (type: TileType.wall, orientation: TileOrientation.vertical),
  2: (type: TileType.wall, orientation: TileOrientation.horizontal),
  3: (type: TileType.corner, orientation: TileOrientation.downLeft),
  4: (type: TileType.wall, orientation: TileOrientation.vertical),
  5: (type: TileType.wall, orientation: TileOrientation.vertical),
  6: (type: TileType.corner, orientation: TileOrientation.upLeft),
  7: (type: TileType.intersection, orientation: TileOrientation.tRight),
  8: (type: TileType.wall, orientation: TileOrientation.horizontal),
  9: (type: TileType.corner, orientation: TileOrientation.downRight),
  10: (type: TileType.wall, orientation: TileOrientation.horizontal),
  11: (type: TileType.intersection, orientation: TileOrientation.tUp),
  12: (type: TileType.corner, orientation: TileOrientation.upRight),
  13: (type: TileType.intersection, orientation: TileOrientation.tLeft),
  14: (type: TileType.intersection, orientation: TileOrientation.tDown),
  15: (type: TileType.intersection, orientation: TileOrientation.cross),
};

const BitmaskToOrientation orientationByBitmaskWater = {
  0: TileOrientation.defaultOrientation,
  1: TileOrientation.up,
  2: TileOrientation.right,
  3: TileOrientation.downLeft,
  4: TileOrientation.down,
  5: TileOrientation.vertical,
  6: TileOrientation.upLeft,
  7: TileOrientation.upRightDown,
  8: TileOrientation.left,
  9: TileOrientation.downRight,
  10: TileOrientation.horizontal,
  11: TileOrientation.upRightLeft,
  12: TileOrientation.upRight,
  13: TileOrientation.upDownLeft,
  14: TileOrientation.downRightLeft,
  15: TileOrientation.all,
};

const BitmaskToOrientation orientationByBitmaskIce = {
  0: TileOrientation.defaultOrientation,
  1: TileOrientation.up,
  2: TileOrientation.right,
  3: TileOrientation.upRight,
  4: TileOrientation.down,
  5: TileOrientation.vertical,
  6: TileOrientation.downRight,
  7: TileOrientation.upRightDown,
  8: TileOrientation.left,
  9: TileOrientation.upLeft,
  10: TileOrientation.horizontal,
  11: TileOrientation.upRightLeft,
  12: TileOrientation.downLeft,
  13: TileOrientation.upDownLeft,
  14: TileOrientation.downRightLeft,
  15: TileOrientation.all,
};
