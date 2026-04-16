import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' show None, Option, Some;
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/constants/character_assets.dart';
import '../../../../../core/constants/ui_assets.dart';
import '../../../core/context/game_session_scope_holder.dart';
import '../../../core/enums/tile_type.dart';
import '../../../core/painters/dashed_path_painter.dart';
import '../../../domain/models/game_board_position.dart';
import '../../../domain/models/tile.dart';
import '../../mappers/path_display_mapper.dart';
import '../../ui_models/components/game_board_cell_path_directions_ui.dart';
import '../../ui_models/components/game_board_cell_ui.dart';
import '../../ui_models/components/game_board_ui_cell_interaction.dart';
import '../../ui_models/components/game_board_ui_tile.dart';
import 'game_board_view_model.dart';

class GameBoardWidget extends StatefulWidget {
  const GameBoardWidget({super.key});

  @override
  State<GameBoardWidget> createState() => _GameBoardWidgetState();
}

class _GameBoardWidgetState extends State<GameBoardWidget> {
  late final GameBoardViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<GameSessionScopeHolder>().scope!
        .get<GameBoardViewModel>();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final board = _viewModel.board.watch(context);
    final selection = _viewModel.selection.watch(context);
    final selectedPosition = selection.position;
    final isSelectionActive = _viewModel.isSelectionActive.watch(context);
    final isInActionMode = _viewModel.isInActionMode.watch(context);
    final reachable = _viewModel.reachableCellCoords.watch(context);
    final movementPath = _viewModel.movementPathCoords.watch(context);
    final pathOrdered = _viewModel.selectedPathOrdered.watch(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxAvailable = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;
        final cellSize = (maxAvailable / board.size).floorToDouble();
        final boardSize = cellSize * board.size;
        return Stack(
          children: [
            Container(
              width: boardSize,
              height: boardSize,
              color: const Color(0xFF2B2B2B),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: board.size * board.size,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: board.size,
                  mainAxisExtent: cellSize,
                ),
                itemBuilder: (context, index) {
                  final x = index ~/ board.size;
                  final y = index % board.size;
                  final cell = board.matrix[x][y];
                  final tileUi = _tileUiForCell(cell);
                  return SizedBox(
                    width: cellSize,
                    height: cellSize,
                    child: ClipRect(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            tileUi.imagePath,
                            fit: BoxFit.fill,
                            errorBuilder: (_, _, _) => Image.asset(
                              tileUi.imagePathBase,
                              fit: BoxFit.fill,
                            ),
                          ),
                          if (cell.isIlluminated)
                            const Positioned.fill(
                              child: IgnorePointer(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: RadialGradient(
                                      radius: 0.95,
                                      colors: [
                                        Color.fromRGBO(255, 220, 100, 0.5),
                                        Color.fromRGBO(255, 200, 50, 0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _ReachableHighlightPainter(
                    reachable: reachable,
                    cellSize: cellSize,
                    gridSize: board.size,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: boardSize,
              height: boardSize,
              child: GridView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: board.size * board.size,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: board.size,
                  mainAxisExtent: cellSize,
                ),
                itemBuilder: (context, index) {
                  final x = index ~/ board.size;
                  final y = index % board.size;
                  final cell = board.matrix[x][y];
                  final pos = GameBoardPosition(x: cell.x, y: cell.y);
                  final onPath = movementPath.contains(pos);
                  final pathDirectionsUi = onPath
                      ? Option.of(
                          GameBoardCellPathDirectionsUi.fromCellPathDirections(
                            pathDirectionsForCell(x, y, pathOrdered),
                          ),
                        )
                      : const Option<GameBoardCellPathDirectionsUi>.none();
                  final isSelected = switch (selectedPosition) {
                    None() => false,
                    Some(value: final p) => cell.x == p.x && cell.y == p.y,
                  };
                  return _GameBoardCellWidget(
                    cell: cell,
                    cellSize: cellSize,
                    interactionState: GameBoardUiCellInteraction(
                      isSelected: isSelected,
                      isSelectionModeActive: isSelectionActive,
                      isActionModeActive: isInActionMode,
                      isReachable: false,
                      isOnMovementPath: onPath,
                      pathDirections: pathDirectionsUi,
                    ),
                    onTap: () => _viewModel.handleCellPrimaryTap(cell),
                    onSecondaryTap: () =>
                        _viewModel.handleCellSecondaryTap(cell),
                    onLongPress: () => _viewModel.handleCellLongPress(cell),
                    contentOnly: true,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  GameBoardUiTile _tileUiForCell(GameBoardCellUi cell) {
    final doorState = switch (cell.tile) {
      DoorTile(:final state) => Option.of(state),
      _ => const Option<TileState>.none(),
    };
    return GameBoardUiTile(
      sourceTile: cell.tile,
      displayType: cell.displayTileType.fold(() => cell.tile.type, (t) => t),
      orientation: cell.tileOrientation,
      doorState: doorState,
      diagonalSuffix: cell.diagonalSuffix,
      cellX: cell.x,
      cellY: cell.y,
    );
  }
}

class _ReachableHighlightPainter extends CustomPainter {
  _ReachableHighlightPainter({
    required this.reachable,
    required this.cellSize,
    required this.gridSize,
  });

  final Set<GameBoardPosition> reachable;
  final double cellSize;
  final int gridSize;

  @override
  void paint(Canvas canvas, Size size) {
    if (reachable.isEmpty) return;
    final paint = Paint()..color = const Color.fromRGBO(255, 0, 0, 0.3);
    for (final pos in reachable) {
      if (pos.x >= 0 && pos.x < gridSize && pos.y >= 0 && pos.y < gridSize) {
        final rect = Rect.fromLTWH(
          pos.y * cellSize,
          pos.x * cellSize,
          cellSize,
          cellSize,
        );
        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ReachableHighlightPainter oldDelegate) =>
      oldDelegate.reachable != reachable ||
      oldDelegate.cellSize != cellSize ||
      oldDelegate.gridSize != gridSize;
}

class _GameBoardCellWidget extends StatelessWidget {
  final GameBoardCellUi cell;
  final double cellSize;
  final GameBoardUiCellInteraction interactionState;
  final VoidCallback onTap;
  final VoidCallback? onSecondaryTap;
  final VoidCallback? onLongPress;
  final bool contentOnly;

  const _GameBoardCellWidget({
    required this.cell,
    required this.cellSize,
    required this.interactionState,
    required this.onTap,
    this.onSecondaryTap,
    this.onLongPress,
    this.contentOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    if (contentOnly) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        onSecondaryTap: onSecondaryTap,
        onLongPress: onLongPress,
        child: SizedBox(
          width: cellSize,
          height: cellSize,
          child: ClipRect(
            child: Stack(
              children: [
                _buildItem(),
                _buildCharacter(),
                if (interactionState.isSelected) _buildSelectionOverlay(),
                if (interactionState.isOnMovementPath &&
                    interactionState.isSelectionModeActive)
                  _buildMovementPathIndicator(),
              ],
            ),
          ),
        ),
      );
    }
    final doorState = switch (cell.tile) {
      DoorTile(:final state) => Option.of(state),
      _ => const Option<TileState>.none(),
    };
    final tileUi = GameBoardUiTile(
      sourceTile: cell.tile,
      displayType: cell.displayTileType.fold(() => cell.tile.type, (t) => t),
      orientation: cell.tileOrientation,
      doorState: doorState,
      diagonalSuffix: cell.diagonalSuffix,
      cellX: cell.x,
      cellY: cell.y,
    );
    return GestureDetector(
      onTap: onTap,
      onSecondaryTap: onSecondaryTap,
      onLongPress: onLongPress,
      child: SizedBox(
        width: cellSize,
        height: cellSize,
        child: ClipRect(
          child: Stack(
            children: [
              _buildTile(tileUi),
              if (interactionState.isReachable) _buildReachableOverlay(),
              _buildItem(),
              _buildCharacter(),
              if (interactionState.isSelected) _buildSelectionOverlay(),
              if (interactionState.isOnMovementPath &&
                  interactionState.isSelectionModeActive)
                _buildMovementPathIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile(GameBoardUiTile tileUi) {
    return Positioned.fill(
      child: Image.asset(
        tileUi.imagePath,
        fit: BoxFit.fill,
        errorBuilder: (_, _, _) =>
            Image.asset(tileUi.imagePathBase, fit: BoxFit.fill),
      ),
    );
  }

  Widget _buildItem() {
    return switch (cell.item) {
      None() => const SizedBox.shrink(),
      Some(value: final itemUi) => Center(
        child: Image.asset(
          itemUi.imagePath,
          width: cellSize * 0.8,
          height: cellSize * 0.8,
        ),
      ),
    };
  }

  Widget _buildCharacter() {
    return switch (cell.character) {
      None() => const SizedBox.shrink(),
      Some(value: final characterUi) => Positioned.fill(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(CharacterAssets.characterShadow, fit: BoxFit.contain),
            Image.asset(characterUi.imagePath, fit: BoxFit.contain),
          ],
        ),
      ),
    };
  }

  Widget _buildSelectionOverlay() {
    if (interactionState.isActionModeActive) {
      return Positioned.fill(
        child: Image.asset(UiAssets.actionTargetOverlay, fit: BoxFit.contain),
      );
    }
    if (interactionState.isSelectionModeActive) {
      return Positioned.fill(
        child: Image.asset(
          UiAssets.movementSelectionOverlay,
          fit: BoxFit.contain,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildMovementPathIndicator() {
    return switch (interactionState.pathDirections) {
      None() => const SizedBox.shrink(),
      Some(value: final dir) => Positioned.fill(
        child: CustomPaint(
          painter: DashedPathPainter(
            hasUp: dir.up,
            hasDown: dir.down,
            hasLeft: dir.left,
            hasRight: dir.right,
          ),
        ),
      ),
    };
  }

  Widget _buildReachableOverlay() {
    return Positioned.fill(
      child: Container(color: const Color.fromRGBO(255, 0, 0, 0.3)),
    );
  }
}
