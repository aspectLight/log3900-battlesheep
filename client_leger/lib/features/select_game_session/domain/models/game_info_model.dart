import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/game_mode.dart';
import '../../../../core/enums/item_type.dart';
import '../../../game_session/core/enums/tile_orientation.dart';
import '../../../game_session/core/enums/tile_type.dart';

part 'game_info_model.freezed.dart';

class GameBoardPreviewCell {
  final TileType tileType;
  final String? tileState;
  final TileOrientation? orientation;
  final ItemType? itemType;

  const GameBoardPreviewCell({
    required this.tileType,
    this.tileState,
    this.orientation,
    this.itemType,
  });
}

@freezed
class GameModelInfo with _$GameModelInfo {
  const factory GameModelInfo({
    required String id,
    required String name,
    required String description,
    required GameMode mode,
    required int boardSize,
    required List<List<GameBoardPreviewCell>> boardMatrix,
    required bool isVisible,
    required String lastModified,
  }) = _GameModelInfo;
}
