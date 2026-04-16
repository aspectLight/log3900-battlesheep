import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/item_type.dart';
import 'game_board_position.dart';

part 'game_item.freezed.dart';

@freezed
class GameItem with _$GameItem {
  const factory GameItem({required ItemType type}) = _GameItem;
}

@freezed
sealed class ItemDropSource with _$ItemDropSource {
  const factory ItemDropSource.player({required String playerId}) =
      PlayerItemDropSource;

  const factory ItemDropSource.disconnected() = DisconnectedItemDropSource;
}

@freezed
class PendingItemPickup with _$PendingItemPickup {
  const factory PendingItemPickup({
    required String playerId,
    required GameItem item,
    required GameBoardPosition cellCoords,
  }) = _PendingItemPickup;
}
