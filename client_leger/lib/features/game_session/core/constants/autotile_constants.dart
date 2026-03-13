import '../enums/tile_orientation.dart';
import '../enums/tile_type.dart';
import '../helpers/build_orientation_map.dart';
import '../typedefs/autotile_typedefs.dart';

final BitmaskToOrientation orientationByBitmaskIce = buildOrientationMap(
  key3: TileOrientation.upRight,
  key6: TileOrientation.downRight,
  key9: TileOrientation.upLeft,
  key12: TileOrientation.downLeft,
);

final BitmaskToOrientation orientationByBitmaskWater = buildOrientationMap(
  key3: TileOrientation.downLeft,
  key6: TileOrientation.upLeft,
  key9: TileOrientation.downRight,
  key12: TileOrientation.upRight,
);

const BitmaskToTypeAndOrientation wallBitmaskToTypeAndOrientation = {
  0: (type: TileType.wall, orientation: TileOrientation.horizontal),
  autotileBitUp: (type: TileType.wall, orientation: TileOrientation.vertical),
  autotileBitRight: (type: TileType.wall, orientation: TileOrientation.horizontal),
  autotileBitUp | autotileBitRight: (type: TileType.corner, orientation: TileOrientation.downLeft),
  autotileBitDown: (type: TileType.wall, orientation: TileOrientation.vertical),
  autotileBitUp | autotileBitDown: (type: TileType.wall, orientation: TileOrientation.vertical),
  autotileBitRight | autotileBitDown: (type: TileType.corner, orientation: TileOrientation.upLeft),
  autotileBitUp | autotileBitRight | autotileBitDown: (type: TileType.intersection, orientation: TileOrientation.tRight),
  autotileBitLeft: (type: TileType.wall, orientation: TileOrientation.horizontal),
  autotileBitUp | autotileBitLeft: (type: TileType.corner, orientation: TileOrientation.downRight),
  autotileBitRight | autotileBitLeft: (type: TileType.wall, orientation: TileOrientation.horizontal),
  autotileBitUp | autotileBitRight | autotileBitLeft: (type: TileType.intersection, orientation: TileOrientation.tUp),
  autotileBitDown | autotileBitLeft: (type: TileType.corner, orientation: TileOrientation.upRight),
  autotileBitUp | autotileBitDown | autotileBitLeft: (type: TileType.intersection, orientation: TileOrientation.tLeft),
  autotileBitRight | autotileBitDown | autotileBitLeft: (type: TileType.intersection, orientation: TileOrientation.tDown),
  autotileBitUp | autotileBitRight | autotileBitDown | autotileBitLeft: (type: TileType.intersection, orientation: TileOrientation.cross),
};
