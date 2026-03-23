import '../../domain/models/tile.dart';
import '../../presentation/mappers/water_path_suffix_mapper.dart';
import '../enums/tile_orientation.dart';
import '../enums/tile_type.dart';

class TileAssets {
  static const String path = 'assets/images/game_board_tiles';

  static const TileOrientation defaultDoorOrientation =
      TileOrientation.horizontal;

  static const List<String> _snowVariantPaths = [
    'snow.png',
    'snow_variant1.png',
    'snow_variant2.png',
  ];

  static String _snowTilePath(int cellX, int cellY) {
    final index = (cellX + cellY) % _snowVariantPaths.length;
    return '$path/${_snowVariantPaths[index]}';
  }

  static String _baseTilePath(TileType type) => switch (type) {
    TileType.door => '$path/door_horizontal_closed.png',
    TileType.corner => '$path/corner_up_left.png',
    TileType.wall => '$path/wall_horizontal.png',
    TileType.intersection => '$path/intersection_cross.png',
    TileType.snow => '$path/snow.png',
    TileType.tree => '$path/tree.png',
    TileType.stone => '$path/stone.png',
    TileType.ice => '$path/ice.png',
    TileType.water => '$path/water.png',
  };

  static String _doorImagePath(TileOrientation? orientation, TileState? state) {
    final orient = orientation ?? defaultDoorOrientation;
    final stateStr = state == TileState.opened ? 'opened' : 'closed';
    return '$path/door_${orient.assetSuffix}_$stateStr.png';
  }

  static String _waterImagePath(
    TileOrientation orientation,
    String? diagonalSuffix,
  ) {
    if (orientation == TileOrientation.all &&
        diagonalSuffix == '_TL_TR_BR_BL') {
      return '$path/water_full.png';
    }
    final useDiagonal = isValidWaterDiagonalSuffix(
      orientation,
      diagonalSuffix ?? '',
    );
    final pathSuffix = useDiagonal
        ? normalizedWaterDiagonalPathSuffix(orientation, diagonalSuffix!)
        : '';
    final suffix = orientation.assetSuffix + pathSuffix;
    return '$path/water_$suffix.png';
  }

  static String _orientedTileImagePath(
    TileType type,
    TileOrientation orientation,
    String pathSuffix,
  ) {
    final suffix = orientation.assetSuffix + pathSuffix;
    return '$path/${type.name}_$suffix.png';
  }

  static String tile(TileType type, [TileState? state]) {
    if (type == TileType.door) {
      return '$path/door_horizontal_'
          '${state == TileState.opened ? 'opened' : 'closed'}.png';
    }
    return _baseTilePath(type);
  }

  static String tileImagePath(
    TileType type,
    TileState? state,
    TileOrientation? orientation, [
    String? diagonalSuffix,
    int? cellX,
    int? cellY,
  ]) {
    if (type == TileType.door) {
      return _doorImagePath(orientation, state);
    }
    if (orientation != null &&
        orientation != TileOrientation.defaultOrientation) {
      const orientTypes = {
        TileType.ice,
        TileType.water,
        TileType.wall,
        TileType.corner,
        TileType.intersection,
      };
      if (orientTypes.contains(type)) {
        if (type == TileType.water) {
          return _waterImagePath(orientation, diagonalSuffix);
        }
        return _orientedTileImagePath(type, orientation, '');
      }
    }
    if (type == TileType.snow && cellX != null && cellY != null) {
      return _snowTilePath(cellX, cellY);
    }
    return tile(type, state);
  }

  static String imagePathFor(Tile tile, [TileOrientation? orientation]) {
    final state = tile is DoorTile ? tile.state : null;
    return tileImagePath(tile.type, state, orientation);
  }
}
