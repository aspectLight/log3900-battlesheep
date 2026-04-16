import 'package:flutter/foundation.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/enums/item_type.dart';
import '../../../core/enums/tile_type.dart';
import '../../../data/repositories/game_board_repository.dart';
import '../../../data/repositories/game_inventory_repository.dart';
import '../../../data/repositories/game_item_repository.dart';
import '../../../data/repositories/game_turn_repository.dart';
import '../../../domain/commands/game_item_commands.dart';
import '../../../domain/models/game_board_position.dart';
import '../../../domain/models/game_item.dart';
import '../../mappers/game_player_inventory_item_ui_mapper.dart';
import '../../ui_models/components/game_player_inventory_slot_ui.dart';

class GamePlayerInventoryViewModel {
  static const _validTorchDropTiles = <TileType>{
    TileType.snow,
    TileType.water,
    TileType.ice,
  };

  final String _roomId;
  final GameInventoryRepository _inventoryRepository;
  final GameBoardRepository _boardRepository;
  final GameTurnRepository _turnRepository;
  final GameItemRepository _itemRepository;
  final String _playerId;

  late final inventorySlots = computed<List<GamePlayerInventorySlotUi>>(() {
    final inventoryState = _inventoryRepository.state.value;
    return toGamePlayerInventorySlots(inventoryState, _playerId);
  });

  late final canDropTorch = computed<bool>(() {
    if (!_turnRepository.state.value.isCurrentSessionPlayerTurn(_playerId)) {
      return false;
    }
    final boardState = _boardRepository.state.value;
    final playerPosition = boardState.playerPositions[_playerId];
    if (playerPosition == null) {
      return false;
    }
    final tileType = boardState.board.matrix[playerPosition.x][playerPosition.y].tile.type;
    return _validTorchDropTiles.contains(tileType);
  });

  GamePlayerInventoryViewModel({
    required String roomId,
    required GameInventoryRepository inventoryRepository,
    required GameBoardRepository boardRepository,
    required GameTurnRepository turnRepository,
    required GameItemRepository itemRepository,
    required String playerId,
  }) : _roomId = roomId,
       _inventoryRepository = inventoryRepository,
       _boardRepository = boardRepository,
       _turnRepository = turnRepository,
       _itemRepository = itemRepository,
       _playerId = playerId;

  void dropTorch() {
    if (!canDropTorch.value) {
      if (kDebugMode) {
        debugPrint(
          '[torch-drop] dropTorch() ignored: canDropTorch is false '
          '(need your turn + snow/water/ice tile)',
        );
      }
      return;
    }

    final boardState = _boardRepository.state.value;
    final playerPosition = boardState.playerPositions[_playerId];
    if (playerPosition == null) {
      if (kDebugMode) {
        debugPrint('[torch-drop] dropTorch() ignored: no playerPosition for $_playerId');
      }
      return;
    }

    if (kDebugMode) {
      debugPrint(
        '[torch-drop] dropTorch() sending itemDropped at '
        '(${playerPosition.x}, ${playerPosition.y}) room=$_roomId',
      );
    }

    final itemDroppedCommand = ItemDroppedCommand(
      roomId: _roomId,
      source: ItemDropSource.player(playerId: _playerId),
      item: const GameItem(type: ItemType.torch),
      coords: GameBoardPosition(x: playerPosition.x, y: playerPosition.y),
    );
    _itemRepository.dropItem(itemDroppedCommand);
  }

  void dispose() {}
}
