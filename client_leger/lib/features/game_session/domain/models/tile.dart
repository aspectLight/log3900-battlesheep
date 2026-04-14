import '../../core/enums/tile_type.dart';

sealed class Tile {
  const Tile();

  TileType get type;

  factory Tile.fromType(TileType type, [String? stateString]) => switch (type) {
    TileType.snow => const SnowTile(),
    TileType.tree => const TreeTile(),
    TileType.stone => const StoneTile(),
    TileType.ice => const IceTile(),
    TileType.water => const WaterTile(),
    TileType.door => DoorTile(_doorStateFromString(stateString)),
    TileType.wall => const WallTile(),
    TileType.corner => const CornerTile(),
    TileType.intersection => const IntersectionTile(),
    TileType.trap => const TrapTile(),
    TileType.teleportPad => TeleportPadTile(
      _normalizeTeleportState(stateString),
    ),
  };
}

TileState _doorStateFromString(String? s) {
  if (s == null) return TileState.closed;
  switch (s.toLowerCase()) {
    case 'opened':
      return TileState.opened;
    default:
      return TileState.closed;
  }
}

String _normalizeTeleportState(String? s) {
  final v = (s ?? 'default').toLowerCase();
  const known = {'default', 'blue', 'green', 'purple', 'red', 'yellow'};
  if (known.contains(v)) return v;
  return 'default';
}

final class SnowTile extends Tile {
  const SnowTile();
  @override
  TileType get type => TileType.snow;
}

final class TreeTile extends Tile {
  const TreeTile();
  @override
  TileType get type => TileType.tree;
}

final class StoneTile extends Tile {
  const StoneTile();
  @override
  TileType get type => TileType.stone;
}

final class IceTile extends Tile {
  const IceTile();
  @override
  TileType get type => TileType.ice;
}

final class WaterTile extends Tile {
  const WaterTile();
  @override
  TileType get type => TileType.water;
}

final class DoorTile extends Tile {
  final TileState state;
  const DoorTile(this.state);
  @override
  TileType get type => TileType.door;

  DoorTile toggle() =>
      DoorTile(state == TileState.opened ? TileState.closed : TileState.opened);
}

final class WallTile extends Tile {
  const WallTile();
  @override
  TileType get type => TileType.wall;
}

final class CornerTile extends Tile {
  const CornerTile();
  @override
  TileType get type => TileType.corner;
}

final class IntersectionTile extends Tile {
  const IntersectionTile();
  @override
  TileType get type => TileType.intersection;
}

final class TrapTile extends Tile {
  const TrapTile();
  @override
  TileType get type => TileType.trap;
}

final class TeleportPadTile extends Tile {
  final String state;
  const TeleportPadTile(this.state);
  @override
  TileType get type => TileType.teleportPad;
}
