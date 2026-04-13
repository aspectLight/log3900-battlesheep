import 'dart:async';

import '../../../../core/enums/item_type.dart';
import '../../../../core/notification/notification_coordinator.dart';
import '../../../../core/notification/notification_intent.dart';
import '../../core/event_bus/game_session_event_bus.dart'
    show GameItemDroppedDisconnected, GameSessionEventBus;
import '../../../../core/interfaces/event_projection.dart';
import '../../domain/commands/game_item_commands.dart';
import '../../domain/commands/game_movement_commands.dart';
import '../../domain/events/game_item_events.dart';
import '../../domain/models/game_board_position.dart';
import '../../domain/models/game_item.dart';
import '../repositories/game_board_repository.dart';
import '../repositories/game_inventory_repository.dart';
import '../repositories/game_item_repository.dart';
import '../repositories/game_player_movement_repository.dart';
import '../repositories/game_player_repository.dart';
import '../repositories/game_turn_repository.dart';
import '../services/game_item_socket.dart';

class GameItemEventsProjection implements EventProjection {
  final GameItemSocket _itemSocket;
  final GameBoardRepository _boardRepository;
  final GameInventoryRepository _inventoryRepository;
  final GamePlayerRepository _playerRepository;
  final GameSessionEventBus _gameSessionEventBus;
  final String _roomId;
  final String _socketId;
  final NotificationCoordinator _notificationCoordinator;
  final GameItemRepository _itemRepository;
  final GamePlayerMovementRepository _movementRepository;
  final GameTurnRepository _turnRepository;

  GameItemEventsProjection({
    required GameItemSocket itemSocket,
    required GameBoardRepository boardRepository,
    required GameInventoryRepository inventoryRepository,
    required GamePlayerRepository playerRepository,
    required GameSessionEventBus gameSessionEventBus,
    required String roomId,
    required String socketId,
    required NotificationCoordinator notificationCoordinator,
    required GameItemRepository itemRepository,
    required GamePlayerMovementRepository movementRepository,
    required GameTurnRepository turnRepository,
  }) : _itemSocket = itemSocket,
       _boardRepository = boardRepository,
       _inventoryRepository = inventoryRepository,
       _playerRepository = playerRepository,
       _gameSessionEventBus = gameSessionEventBus,
       _roomId = roomId,
       _socketId = socketId,
       _notificationCoordinator = notificationCoordinator,
       _itemRepository = itemRepository,
       _movementRepository = movementRepository,
       _turnRepository = turnRepository;

  @override
  List<StreamSubscription> subscribe() => [
    _itemSocket.itemDroppedStream.listen(_onItemDropped),
    _itemSocket.itemCollectedStream.listen(_onItemCollected),
    _itemSocket.itemDroppedDisconnectedStream.listen(
      _onItemDroppedDisconnected,
    ),
    _itemSocket.flagCollectedStream.listen(
      _inventoryRepository.applyFlagCollected,
    ),
  ];

  void _onItemCollected(ItemCollectedEvent event) {
    _boardRepository.applyItemCollected(event);
    if (event.inventoryFull) {
      if (event.playerId == _socketId) {
        final pos = event.position;
        if (pos != null) {
          _showInventoryFullReplacement(event, pos);
        }
      }
      return;
    }
    _inventoryRepository.applyItemCollected(event);
    _playerRepository.applyItemCollected(event);
    _refreshPathsAfterItemCollected(event);
  }

  void _showInventoryFullReplacement(
    ItemCollectedEvent event,
    GameBoardPosition pos,
  ) {
    final inv =
        _inventoryRepository.state.value.itemsByPlayerId[event.playerId] ?? [];
    _notificationCoordinator.addIntent(
      InventoryFullDiscardIntent(
        candidateItems: [...inv.map((e) => e.type), event.item.type],
        onComplete: (discarded) => discarded.fold(
          () {},
          (ItemType itemType) {
            if (itemType == event.item.type) {
              _itemRepository.dropItem(
                ItemDroppedCommand(
                  roomId: _roomId,
                  source: PlayerItemDropSource(playerId: event.playerId),
                  item: GameItem(type: itemType),
                  coords: pos,
                ),
              );
            } else {
              final item = GameItem(type: itemType);
              final dropEv = ItemDroppedEvent(
                roomId: _roomId,
                playerId: event.playerId,
                item: item,
                coords: pos,
              );
              _inventoryRepository.applyItemDropped(dropEv);
              _playerRepository.applyItemDropped(dropEv);
              _itemRepository.dropItem(
                ItemDroppedCommand(
                  roomId: _roomId,
                  source: PlayerItemDropSource(playerId: event.playerId),
                  item: item,
                  coords: pos,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _refreshPathsAfterItemCollected(ItemCollectedEvent event) {
    if (event.playerId != _socketId) return;
    if (_turnRepository.state.value.currentPlayerId != _socketId) return;
    if (event.item.type != ItemType.waterproofBoots) return;
    final inv =
        _inventoryRepository.state.value.itemsByPlayerId[_socketId] ?? [];
    _movementRepository.getMovements(
      PlayerGetMovementsCommand(
        roomId: _roomId,
        hasBoots: inv.any((item) => item.type == ItemType.waterproofBoots),
      ),
    );
  }

  void _onItemDropped(ItemDroppedEvent event) {
    _boardRepository.applyItemDropped(event);
    _inventoryRepository.applyItemDropped(event);
    _playerRepository.applyItemDropped(event);
  }

  void _onItemDroppedDisconnected(ItemDroppedDisconnectedEvent event) {
    _inventoryRepository.applyItemDroppedDisconnected(event);
    _playerRepository.applyItemDroppedDisconnected(event);
    _gameSessionEventBus.fire(GameItemDroppedDisconnected(event));
  }
}
