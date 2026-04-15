import 'package:signals_flutter/signals_flutter.dart';

import '../../../data/repositories/game_inventory_repository.dart';
import '../../mappers/game_player_inventory_item_ui_mapper.dart';
import '../../ui_models/components/game_player_inventory_slot_ui.dart';

class GamePlayerInventoryViewModel {
  final GameInventoryRepository _inventoryRepository;
  final String _playerId;

  late final inventorySlots = computed<List<GamePlayerInventorySlotUi>>(() {
    final inventoryState = _inventoryRepository.state.value;
    return toGamePlayerInventorySlots(inventoryState, _playerId);
  });

  GamePlayerInventoryViewModel({
    required GameInventoryRepository inventoryRepository,
    required String playerId,
  }) : _inventoryRepository = inventoryRepository,
       _playerId = playerId;

  void dispose() {}
}
