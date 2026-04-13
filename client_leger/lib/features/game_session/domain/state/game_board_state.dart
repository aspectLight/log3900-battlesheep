import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fpdart/fpdart.dart';

import '../../core/extensions/tile_type_ext.dart';
import '../../core/enums/tile_orientation.dart';
import '../models/game_board_position.dart';
import '../models/game_item.dart';
import '../models/tile.dart';
import 'game_player_state.dart';

part 'game_board_state.freezed.dart';

class BoardCell {
  final Tile tile;
  final GameBoardPosition position;
  final TileOrientation? tileOrientation;
  final bool hasPathUp;
  final bool hasPathDown;
  final bool hasPathLeft;
  final bool hasPathRight;

  const BoardCell({
    required this.tile,
    required this.position,
    this.tileOrientation,
    this.hasPathUp = false,
    this.hasPathDown = false,
    this.hasPathLeft = false,
    this.hasPathRight = false,
  });

  int get x => position.x;
  int get y => position.y;

  bool isAtSpawn(GamePlayer player) =>
      x == player.spawnPoint.x && y == player.spawnPoint.y;

  bool isEmpty(GameBoardState state) {
    final hasPlayer = state.playerPositions.values
        .any((p) => p.x == position.x && p.y == position.y);
    return !hasPlayer &&
        !state.items.containsKey(position) &&
        tile.isReachableForMovement;
  }

  BoardCell copyWith({
    Tile? tile,
    GameBoardPosition? position,
    TileOrientation? tileOrientation,
    bool? hasPathUp,
    bool? hasPathDown,
    bool? hasPathLeft,
    bool? hasPathRight,
  }) {
    return BoardCell(
      tile: tile ?? this.tile,
      position: position ?? this.position,
      tileOrientation: tileOrientation ?? this.tileOrientation,
      hasPathUp: hasPathUp ?? this.hasPathUp,
      hasPathDown: hasPathDown ?? this.hasPathDown,
      hasPathLeft: hasPathLeft ?? this.hasPathLeft,
      hasPathRight: hasPathRight ?? this.hasPathRight,
    );
  }
}

class Board {
  final List<List<BoardCell>> matrix;
  final int size;

  Board({required this.matrix, required this.size});

  factory Board.defaultBoard(int size) {
    final matrix = <List<BoardCell>>[];
    for (var i = 0; i < size; i++) {
      final row = <BoardCell>[];
      for (var j = 0; j < size; j++) {
        row.add(
          BoardCell(
            tile: const SnowTile(),
            position: GameBoardPosition(x: i, y: j),
          ),
        );
      }
      matrix.add(row);
    }
    return Board(matrix: matrix, size: size);
  }

  Board copyWith({List<List<BoardCell>>? matrix, int? size}) {
    return Board(matrix: matrix ?? this.matrix, size: size ?? this.size);
  }

  bool isInBounds(int x, int y) =>
      x >= 0 && y >= 0 && x < size && y < size;

  Option<BoardCell> cellForPlayer(
    Map<String, GameBoardPosition> positions,
    String playerId,
  ) {
    final pos = positions[playerId];
    if (pos == null || !isInBounds(pos.x, pos.y)) return const Option.none();
    return Option.of(matrix[pos.x][pos.y]);
  }
}

@freezed
class GameBoardState with _$GameBoardState {
  const factory GameBoardState({
    required Board board,
    required Map<GameBoardPosition, GameItem> items,
    required Map<String, GameBoardPosition> playerPositions,
    required Set<GameBoardPosition> reachableCellCoords,
    required Map<GameBoardPosition, List<GameBoardPosition>>
        reachablePathsByDestination,
    required List<GameBoardPosition> selectedPathCoords,
    @Default(Option.none()) Option<PendingItemPickup> pendingItemPickup,
    @Default({}) Set<String> illuminatedCellKeys,
  }) = _GameBoardState;

  const GameBoardState._();

  Option<GameItem> itemAtPathDestination(List<GameBoardPosition> path) {
    if (path.isEmpty) return const Option.none();
    return Option.fromNullable(items[path.last]);
  }

  factory GameBoardState.scopedInitial({
    required Board board,
    Map<GameBoardPosition, GameItem>? items,
  }) =>
      GameBoardState(
        board: board,
        items: items ?? const {},
        playerPositions: const {},
        reachableCellCoords: const {},
        reachablePathsByDestination: const {},
        selectedPathCoords: const [],
      );
}
