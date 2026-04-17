import '../../../../../core/enums/item_type.dart';
import '../models/game_board_position.dart';
import '../models/game_item.dart';
import '../state/game_board_state.dart';

/// Même logique que le client web au chargement de partie : résout les cases
/// `random` avec une graine dérivée du [roomId] et retire les doublons d’items
/// uniques comme sur le plateau Angular.
Map<GameBoardPosition, GameItem> resolveRandomBoardItems({
  required Map<GameBoardPosition, GameItem> items,
  required Board board,
  required String roomId,
}) {
  final next = Map<GameBoardPosition, GameItem>.from(items);
  final remaining = <ItemType>{...ItemType.values};

  var seedSum = 0;
  for (final c in roomId.codeUnits) {
    seedSum += c;
  }
  final seed = seedSum.abs();

  for (var i = 0; i < board.size; i++) {
    for (var j = 0; j < board.size; j++) {
      final pos = GameBoardPosition(x: i, y: j);
      final item = next[pos];
      if (item == null) continue;

      if (item.type == ItemType.spawnPoint) {
        continue;
      }
      if (item.type == ItemType.random) {
        final candidates = ItemType.values
            .where(
              (t) =>
                  remaining.contains(t) &&
                  t != ItemType.random &&
                  t != ItemType.spawnPoint &&
                  t != ItemType.flag,
            )
            .toList();
        if (candidates.isEmpty) {
          next.remove(pos);
        } else {
          final picked = candidates[seed % candidates.length];
          next[pos] = GameItem(type: picked);
          remaining.remove(picked);
        }
      } else if (remaining.contains(item.type)) {
        remaining.remove(item.type);
      } else {
        next.remove(pos);
      }
    }
  }
  return next;
}
