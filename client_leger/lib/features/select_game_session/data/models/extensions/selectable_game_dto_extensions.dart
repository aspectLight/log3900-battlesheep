import '../../../domain/models/game_info_model.dart';
import '../dto/game_summary_dto.dart';
import '../../../../game_session/core/enums/tile_type.dart';
import '../../../../game_session/core/enums/tile_orientation.dart';
import '../../../../../core/enums/item_type.dart';

List<List<GameBoardPreviewCell>> previewMatrixFromGameSummaryBoard(
  GameSummaryBoardDto board,
) {
  if (board.matrix == null || board.matrix!.isEmpty) {
    return defaultPreviewBoardMatrix(board.size);
  }
  return board.matrix!
      .map(
        (row) => row
            .map(
              (cell) => GameBoardPreviewCell(
                tileType: tileTypeFromServerString(cell.tileType),
                tileState: tileStateFromServerString(cell.tileState),
                orientation: tileOrientationFromServerString(
                  cell.tileOrientation,
                ),
                itemType: itemTypeFromServerString(cell.itemType),
              ),
            )
            .toList(),
      )
      .toList();
}

List<List<GameBoardPreviewCell>> defaultPreviewBoardMatrix(int size) {
  if (size <= 0) return [];
  final row = List<GameBoardPreviewCell>.generate(
    size,
    (_) => const GameBoardPreviewCell(tileType: TileType.snow),
  );
  return List<List<GameBoardPreviewCell>>.generate(
    size,
    (_) => List<GameBoardPreviewCell>.from(row),
  );
}

TileType tileTypeFromServerString(String serverType) {
  for (final t in TileType.values) {
    if (t.name == serverType) return t;
  }
  return TileType.snow;
}

TileState? tileStateFromServerString(String? serverState) {
  if (serverState == null) return null;
  for (final s in TileState.values) {
    if (s.name == serverState) return s;
  }
  return null;
}

TileOrientation? tileOrientationFromServerString(String? serverOrientation) {
  if (serverOrientation == null) return null;
  final lower = serverOrientation.toLowerCase();
  for (final o in TileOrientation.values) {
    if (o.serverValue.toLowerCase() == lower) return o;
  }
  return null;
}

ItemType? itemTypeFromServerString(String? serverItemType) {
  if (serverItemType == null) return null;
  for (final i in ItemType.values) {
    if (i.name == serverItemType) return i;
  }
  return null;
}

extension GameSummaryDtoToModel on GameSummaryDto {
  GameModelInfo toModel() => GameModelInfo(
        id: id,
        name: name,
        description: description,
        mode: mode,
        boardSize: board.size,
        boardMatrix: previewMatrixFromGameSummaryBoard(board),
        privacy: privacy,
        owner: owner,
        actionPoints: actionPoints,
        lastModified: modificationDate,
      );
}
