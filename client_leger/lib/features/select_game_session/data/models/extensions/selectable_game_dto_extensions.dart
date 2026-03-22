import '../../../domain/models/game_info_model.dart';
import '../dto/game_summary_dto.dart';
import '../../../../game_session/core/enums/tile_type.dart';
import '../../../../game_session/core/enums/tile_orientation.dart';
import '../../../../../core/enums/item_type.dart';

extension GameSummaryDtoToModel on GameSummaryDto {
  GameModelInfo toModel() => GameModelInfo(
    id: id,
    name: name,
    description: description,
    mode: mode,
    boardSize: board.size,
    boardMatrix: board.matrix == null
        ? _defaultBoardMatrix(board.size)
        : board.matrix!
            .map(
              (row) => row
                  .map(
                    (cell) => GameBoardPreviewCell(
                      tileType: _tileTypeFromServer(cell.tileType),
                      tileState: _tileStateFromServer(cell.tileState),
                      orientation: _tileOrientationFromServer(
                        cell.tileOrientation,
                      ),
                      itemType: _itemTypeFromServer(cell.itemType),
                    ),
                  )
                  .toList(),
            )
            .toList(),
    isVisible: isVisible,
    lastModified: modificationDate,
  );

  List<List<GameBoardPreviewCell>> _defaultBoardMatrix(int size) {
    final row = List<GameBoardPreviewCell>.generate(
      size,
      (_) => const GameBoardPreviewCell(tileType: TileType.snow),
    );
    return List<List<GameBoardPreviewCell>>.generate(
      size,
      (_) => List<GameBoardPreviewCell>.from(row),
    );
  }

  TileType _tileTypeFromServer(String serverType) {
    for (final t in TileType.values) {
      if (t.name == serverType) return t;
    }
    return TileType.snow;
  }

  TileState? _tileStateFromServer(String? serverState) {
    if (serverState == null) return null;
    for (final s in TileState.values) {
      if (s.name == serverState) return s;
    }
    return null;
  }

  TileOrientation? _tileOrientationFromServer(String? serverOrientation) {
    if (serverOrientation == null) return null;
    final lower = serverOrientation.toLowerCase();
    for (final o in TileOrientation.values) {
      if (o.serverValue.toLowerCase() == lower) return o;
    }
    return null;
  }

  ItemType? _itemTypeFromServer(String? serverItemType) {
    if (serverItemType == null) return null;
    for (final i in ItemType.values) {
      if (i.name == serverItemType) return i;
    }
    return null;
  }
}
