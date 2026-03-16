import '../../core/constants/game_rules_constants.dart';
import '../../core/event_bus/game_session_event_bus.dart';
import '../../../../core/enums/item_type.dart';
import '../../../../core/notification/notification_intent.dart';
import '../../../../core/notification/notification_intent_sink.dart';
import '../../domain/models/game_item.dart';
import '../../data/repositories/game_board_repository.dart';
import '../../data/repositories/game_inventory_repository.dart';
import '../../data/repositories/game_item_repository.dart';
import '../../domain/commands/game_item_commands.dart';
import '../../domain/events/game_item_events.dart';
import '../../../../core/interfaces/disposable_side_effect.dart';

class GamePendingItemPickupSideEffect with DisposableSideEffect {
  final String _roomId;
  final String _socketId;
  final GameSessionEventBus _gameSessionEventBus;
  final GameBoardRepository _boardRepository;
  final GameInventoryRepository _inventoryRepository;
  final GameItemRepository _itemRepository;
  final NotificationIntentSink _notificationIntentSink;

  GamePendingItemPickupSideEffect({
    required String roomId,
    required String socketId,
    required GameSessionEventBus gameSessionEventBus,
    required GameBoardRepository boardRepository,
    required GameInventoryRepository inventoryRepository,
    required GameItemRepository itemRepository,
    required NotificationIntentSink notificationIntentSink,
  }) : _roomId = roomId,
       _socketId = socketId,
       _gameSessionEventBus = gameSessionEventBus,
       _boardRepository = boardRepository,
       _inventoryRepository = inventoryRepository,
       _itemRepository = itemRepository,
       _notificationIntentSink = notificationIntentSink {
    trackSubscription(
      _gameSessionEventBus.on<PendingItemPickupReadyEvent>().listen(
        _onPendingItemPickupReady,
      ),
    );
  }

  void _onPendingItemPickupReady(PendingItemPickupReadyEvent event) {
    final p = event.pending;
    if (p.playerId != _socketId) return;
    final inv =
        _inventoryRepository.state.value.itemsByPlayerId[p.playerId] ?? [];
    if (inv.length < GameRulesConstants.inventorySlotCount) {
      _collectItemAndClear(p);
      return;
    }
    _notificationIntentSink.addIntent(
      InventoryFullDiscardIntent(
        candidateItems: [...inv.map((e) => e.type), p.item.type],
        onComplete: (discarded) => discarded.fold(
          _boardRepository.clearPendingItemPickup,
          (ItemType itemType) {
            if (itemType == p.item.type) {
              _boardRepository.clearPendingItemPickup();
              return;
            }
            final item = GameItem(type: itemType);
            _inventoryRepository.applyItemDropped(
              ItemDroppedEvent(
                roomId: _roomId,
                playerId: p.playerId,
                item: item,
                coords: p.cellCoords,
              ),
            );
            _collectItemAndClear(p);
            _itemRepository.dropItem(
              ItemDroppedCommand(
                roomId: _roomId,
                source: PlayerItemDropSource(playerId: p.playerId),
                item: item,
                coords: p.cellCoords,
              ),
            );
          },
        ),
      ),
    );
  }

  void _collectItemAndClear(PendingItemPickup pending) {
    _itemRepository.collectItem(
      ItemCollectedCommand(
        roomId: _roomId,
        playerId: pending.playerId,
        item: pending.item,
        position: pending.cellCoords,
      ),
    );
    _boardRepository.clearPendingItemPickup();
  }
}
