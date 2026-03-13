import 'package:fpdart/fpdart.dart';

import '../../../core/definitions/item_definition.dart';
import '../../../core/definitions/tile_definition.dart';

sealed class GameCellDetailUiState {
  const GameCellDetailUiState();
}

final class GameCellDetailEmpty extends GameCellDetailUiState {
  const GameCellDetailEmpty();
}

final class GameCellDetailPlayer extends GameCellDetailUiState {
  final GameCellDetailPlayerInfo info;

  const GameCellDetailPlayer(this.info);
}

final class GameCellDetailTile extends GameCellDetailUiState {
  final TileDefinition info;

  const GameCellDetailTile(this.info);
}

final class GameCellDetailItem extends GameCellDetailUiState {
  final ItemDefinition info;

  const GameCellDetailItem(this.info);
}

class GameCellDetailPlayerInfo {
  final String name;
  final Option<String> avatarPath;
  final Option<String> avatarFullPath;
  final bool isCurrentPlayer;

  const GameCellDetailPlayerInfo({
    required this.name,
    required this.isCurrentPlayer,
    required this.avatarPath,
    required this.avatarFullPath,
  });
}

typedef GameCellDetailTileInfo = TileDefinition;
typedef GameCellDetailItemInfo = ItemDefinition;
