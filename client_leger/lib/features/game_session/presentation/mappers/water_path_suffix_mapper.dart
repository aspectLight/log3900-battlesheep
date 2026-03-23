import '../../core/enums/tile_orientation.dart';

const Map<TileOrientation, Set<String>> validWaterDiagonalSuffixes = {
  TileOrientation.upRight: {'_BL'},
  TileOrientation.downRight: {'_TL'},
  TileOrientation.upRightDown: {'_TR', '_BR', '_TR_BR'},
  TileOrientation.upLeft: {'_BR'},
  TileOrientation.upRightLeft: {'_TL', '_TR', '_TL_TR'},
  TileOrientation.downLeft: {'_TR'},
  TileOrientation.upDownLeft: {'_BL', '_TL', '_TL_BL'},
  TileOrientation.downRightLeft: {'_BR', '_BL', '_BR_BL'},
  TileOrientation.all: {
    '_TL_TR_BR_BL', '_BR', '_BL', '_TL', '_TR',
    '_TL_BL', '_TL_BR', '_TR_BL', '_TL_TR', '_TR_BR', '_BR_BL',
    '_TR_BR_BL', '_TL_BR_BL', '_TL_TR_BL', '_TL_TR_BR',
  },
};

bool isValidWaterDiagonalSuffix(TileOrientation orientation, String suffix) {
  return suffix.isNotEmpty &&
      (validWaterDiagonalSuffixes[orientation]?.contains(suffix) ?? false);
}

String normalizedWaterDiagonalPathSuffix(
  TileOrientation orientation,
  String diagonalSuffix,
) {
  if (orientation == TileOrientation.upRightLeft &&
      diagonalSuffix == '_TL_TR') {
    return '_TR_TL';
  }
  if (orientation == TileOrientation.downRightLeft &&
      diagonalSuffix == '_BR_BL') {
    return '_BL_BR';
  }
  return diagonalSuffix;
}
