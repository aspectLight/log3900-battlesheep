import '../constants/tile_assets.dart';
import '../enums/tile_type.dart';
import '../../domain/models/tile.dart';

class TileDefinition {
  final int baseMoveModifier;
  final Tile tile;

  const TileDefinition._({required this.baseMoveModifier, required this.tile});

  TileType get type => tile.type;
  String get imagePath => TileAssets.imagePathFor(tile);
  bool get isWalkable => baseMoveModifier >= 0;
  bool get isBlocking => baseMoveModifier < 0;

  factory TileDefinition.fromTile(Tile tile) => switch (tile) {
    SnowTile() => TileDefinition._(baseMoveModifier: 1, tile: tile),
    TreeTile() => TileDefinition._(baseMoveModifier: -1, tile: tile),
    StoneTile() => TileDefinition._(baseMoveModifier: -1, tile: tile),
    IceTile() => TileDefinition._(baseMoveModifier: 0, tile: tile),
    WaterTile() => TileDefinition._(baseMoveModifier: 2, tile: tile),
    DoorTile() => TileDefinition._(baseMoveModifier: -1, tile: tile),
    WallTile() => TileDefinition._(baseMoveModifier: -1, tile: tile),
    CornerTile() => TileDefinition._(baseMoveModifier: -1, tile: tile),
    IntersectionTile() => TileDefinition._(baseMoveModifier: -1, tile: tile),
    TrapTile() => TileDefinition._(baseMoveModifier: 1, tile: tile),
    TeleportPadTile() => TileDefinition._(baseMoveModifier: 1, tile: tile),
  };

  factory TileDefinition.fromType(TileType type, [String? stateString]) {
    return TileDefinition.fromTile(Tile.fromType(type, stateString));
  }
}
