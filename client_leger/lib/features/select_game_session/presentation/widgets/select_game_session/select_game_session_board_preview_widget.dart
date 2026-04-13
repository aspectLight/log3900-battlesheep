import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' as fp;

import '../../../domain/models/game_info_model.dart';
import '../../../../game_session/core/enums/tile_type.dart';
import '../../../../game_session/domain/models/game_board_position.dart';
import '../../../../game_session/domain/models/game_item.dart';
import '../../../../game_session/domain/models/tile.dart';
import '../../../../game_session/domain/state/game_board_state.dart';
import '../../../../game_session/domain/state/game_player_state.dart';
import '../../../../game_session/presentation/mappers/game_board_cell_ui_mapper.dart';
import '../../../../game_session/presentation/ui_models/components/game_board_cell_ui.dart';
import '../../../../game_session/presentation/ui_models/components/game_board_ui_tile.dart';
import '../../../../game_session/presentation/ui_models/components/game_board_ui.dart';

class SelectGameSessionBoardPreviewWidget extends StatefulWidget {
  const SelectGameSessionBoardPreviewWidget({
    super.key,
    required this.boardSize,
    required this.boardMatrix,
  });

  final int boardSize;
  final List<List<GameBoardPreviewCell>> boardMatrix;

  @override
  State<SelectGameSessionBoardPreviewWidget> createState() =>
      _SelectGameSessionBoardPreviewWidgetState();
}

class _SelectGameSessionBoardPreviewWidgetState
    extends State<SelectGameSessionBoardPreviewWidget> {
  late final GameBoardUi _boardUi = _buildBoardUi();

  GameBoardUi _buildBoardUi() {
    final matrix = <List<BoardCell>>[];
    final items = <GameBoardPosition, GameItem>{};

    for (var x = 0; x < widget.boardSize; x++) {
      final row = <BoardCell>[];
      for (var y = 0; y < widget.boardSize; y++) {
        final previewCell = widget.boardMatrix[x][y];
        final position = GameBoardPosition(x: x, y: y);
        final tile = Tile.fromType(previewCell.tileType, previewCell.tileState);

        if (previewCell.itemType != null) {
          items[position] = GameItem(type: previewCell.itemType!);
        }

        row.add(
          BoardCell(
            tile: tile,
            position: position,
            tileOrientation: previewCell.orientation,
          ),
        );
      }
      matrix.add(row);
    }

    final board = Board(matrix: matrix, size: widget.boardSize);
    final boardState = GameBoardState.scopedInitial(
      board: board,
      items: items,
    );
    final playerState = GamePlayerState.initial();

    return toGameBoardUi(
      board,
      playerState,
      boardState,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final side = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;
        if (side <= 0) {
          return const SizedBox.shrink();
        }
        final cellSize = side / _boardUi.size;
        return SizedBox(
          width: side,
          height: side,
          child: ClipRect(
            child: GridView.count(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: _boardUi.size,
              children: List.generate(
                _boardUi.size * _boardUi.size,
                (index) {
                  final x = index ~/ _boardUi.size;
                  final y = index % _boardUi.size;
                  final cell = _boardUi.matrix[x][y];
                  return _CellUiRenderer(
                    cell: cell,
                    cellSize: cellSize,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CellUiRenderer extends StatelessWidget {
  const _CellUiRenderer({
    required this.cell,
    required this.cellSize,
  });

  final GameBoardCellUi cell;
  final double cellSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cellSize,
      height: cellSize,
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              GameBoardUiTile(
                sourceTile: cell.tile,
                displayType: cell.displayTileType
                    .fold(() => cell.tile.type, (t) => t),
                orientation: cell.tileOrientation,
                doorState: switch (cell.tile) {
                  DoorTile(:final state) => fp.Option.of(state),
                  _ => const fp.Option<TileState>.none(),
                },
                diagonalSuffix: cell.diagonalSuffix,
                cellX: cell.x,
                cellY: cell.y,
              ).imagePath,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                GameBoardUiTile(
                  sourceTile: cell.tile,
                  displayType: cell.displayTileType
                      .fold(() => cell.tile.type, (t) => t),
                  orientation: cell.tileOrientation,
                  doorState: switch (cell.tile) {
                    DoorTile(:final state) => fp.Option.of(state),
                    _ => const fp.Option<TileState>.none(),
                  },
                  diagonalSuffix: cell.diagonalSuffix,
                  cellX: cell.x,
                  cellY: cell.y,
                ).imagePathBase,
                fit: BoxFit.fill,
              ),
            ),
            switch (cell.item) {
              fp.None() => const SizedBox.shrink(),
              fp.Some(value: final itemUi) => Center(
                child: Image.asset(
                  itemUi.imagePath,
                  width: cellSize * 0.8,
                  height: cellSize * 0.8,
                ),
              ),
            },
          ],
        ),
      ),
    );
  }
}

