import 'dart:async';

import '../../core/event_bus/game_session_event_bus.dart';
import '../../../../core/interfaces/event_projection.dart';
import '../../domain/events/game_item_events.dart';
import '../repositories/game_board_repository.dart';
import '../repositories/game_inventory_repository.dart';
import '../repositories/game_player_repository.dart';
import '../services/game_item_socket.dart';

class GameItemEventsProjection implements EventProjection {
  final GameItemSocket _itemSocket;
  final GameBoardRepository _boardRepository;
  final GameInventoryRepository _inventoryRepository;
  final GamePlayerRepository _playerRepository;
  final GameSessionEventBus _gameSessionEventBus;

  GameItemEventsProjection({
    required GameItemSocket itemSocket,
    required GameBoardRepository boardRepository,
    required GameInventoryRepository inventoryRepository,
    required GamePlayerRepository playerRepository,
    required GameSessionEventBus gameSessionEventBus,
  }) : _itemSocket = itemSocket,
       _boardRepository = boardRepository,
       _inventoryRepository = inventoryRepository,
       _playerRepository = playerRepository,
       _gameSessionEventBus = gameSessionEventBus;

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
    _inventoryRepository.applyItemCollected(event);
    _playerRepository.applyItemCollected(event);
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
