import '../localisation/game_session_localizations.dart';
import '../enums/tile_type.dart';
import '../../domain/models/tile.dart';

extension TileReachability on Tile {
  bool get isReachableForMovement => switch (this) {
    SnowTile() => true,
    IceTile() => true,
    WaterTile() => true,
    DoorTile(:final state) => state == TileState.opened,
    TrapTile() => true,
    TeleportPadTile() => true,
    TreeTile() => false,
    StoneTile() => false,
    WallTile() => false,
    CornerTile() => false,
    IntersectionTile() => false,
  };
}

extension TileTypeExtension on TileType {
  String getName(GameSessionLocalizations l10n) => switch (this) {
    TileType.snow => l10n.tileSnowName,
    TileType.tree => l10n.tileTreeName,
    TileType.stone => l10n.tileStoneName,
    TileType.ice => l10n.tileIceName,
    TileType.water => l10n.tileWaterName,
    TileType.door => l10n.tileDoorName,
    TileType.wall => l10n.tileWallName,
    TileType.corner => l10n.tileCornerName,
    TileType.intersection => l10n.tileIntersectionName,
    TileType.trap => l10n.tileTrapName,
    TileType.teleportPad => l10n.tileTeleportPadName,
  };

  String getDescription(GameSessionLocalizations l10n) => switch (this) {
    TileType.snow => l10n.tileSnowDesc,
    TileType.tree => l10n.tileTreeDesc,
    TileType.stone => l10n.tileStoneDesc,
    TileType.ice => l10n.tileIceDesc,
    TileType.water => l10n.tileWaterDesc,
    TileType.door => l10n.tileDoorDesc,
    TileType.wall => l10n.tileWallDesc,
    TileType.corner => l10n.tileCornerDesc,
    TileType.intersection => l10n.tileIntersectionDesc,
    TileType.trap => l10n.tileTrapDesc,
    TileType.teleportPad => l10n.tileTeleportPadDesc,
  };
}

extension TileExtension on Tile {
  String getName(GameSessionLocalizations l10n) => type.getName(l10n);
  String getDescription(GameSessionLocalizations l10n) => type.getDescription(l10n);
}
