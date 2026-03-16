import '../enums/tile_orientation.dart';
import '../typedefs/autotile_typedefs.dart';

const int autotileBitUp = 1 << 0;
const int autotileBitRight = 1 << 1;
const int autotileBitDown = 1 << 2;
const int autotileBitLeft = 1 << 3;

BitmaskToOrientation buildOrientationMap({
  required TileOrientation key3,
  required TileOrientation key6,
  required TileOrientation key9,
  required TileOrientation key12,
}) =>
    {
      0: TileOrientation.defaultOrientation,
      autotileBitUp: TileOrientation.up,
      autotileBitRight: TileOrientation.right,
      autotileBitUp | autotileBitRight: key3,
      autotileBitDown: TileOrientation.down,
      autotileBitUp | autotileBitDown: TileOrientation.vertical,
      autotileBitRight | autotileBitDown: key6,
      autotileBitUp | autotileBitRight | autotileBitDown: TileOrientation.upRightDown,
      autotileBitLeft: TileOrientation.left,
      autotileBitUp | autotileBitLeft: key9,
      autotileBitRight | autotileBitLeft: TileOrientation.horizontal,
      autotileBitUp | autotileBitRight | autotileBitLeft: TileOrientation.upRightLeft,
      autotileBitDown | autotileBitLeft: key12,
      autotileBitUp | autotileBitDown | autotileBitLeft: TileOrientation.upDownLeft,
      autotileBitRight | autotileBitDown | autotileBitLeft: TileOrientation.downRightLeft,
      autotileBitUp | autotileBitRight | autotileBitDown | autotileBitLeft: TileOrientation.all,
    };
