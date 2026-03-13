import 'package:fpdart/fpdart.dart';

import '../enums/tile_orientation.dart';
import '../enums/tile_type.dart';

typedef BitmaskToOrientation = Map<int, TileOrientation>;

typedef TileTypeAndOrientation = ({
  TileType type,
  TileOrientation orientation,
});

typedef BitmaskToTypeAndOrientation = Map<int, TileTypeAndOrientation>;

typedef AutotileResult = ({
  Option<TileType> displayType,
  TileOrientation orientation,
  Option<String> diagonalSuffix,
});
