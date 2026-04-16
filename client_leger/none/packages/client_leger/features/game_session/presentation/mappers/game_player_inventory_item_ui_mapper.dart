import 'package:fpdart/fpdart.dart';

import '../../core/constants/game_rules_constants.dart';
import '../../domain/state/game_inventory_state.dart';
import '../ui_models/components/game_player_inventory_item_ui.dart';
import '../ui_models/components/game_player_inventory_slot_ui.dart';

List<GamePlayerInventorySlotUi> toGamePlayerInventorySlots(
  GameInventoryState inventoryState,
  String playerId,
) {
  final raw = inventoryState.getItems(playerId);
  return List.generate(GameRulesConstants.inventorySlotCount, (i) {
    final Option<GamePlayerInventoryItemUi> item = i < raw.length
        ? Option.of(GamePlayerInventoryItemUi(type: raw[i].type))
        : const Option.none();
    return GamePlayerInventorySlotUi(item: item);
  });
}
