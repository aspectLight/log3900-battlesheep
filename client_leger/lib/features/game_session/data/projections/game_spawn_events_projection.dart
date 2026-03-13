import 'dart:async';

import '../../../../core/interfaces/event_projection.dart';
import '../../data/repositories/game_board_repository.dart';
import '../../data/repositories/game_inventory_repository.dart';
import '../../data/repositories/game_player_repository.dart';
import '../../data/services/game_events_socket.dart';
import '../../domain/events/game_events.dart';

class GameSpawnEventsProjection implements EventProjection {
  final GameEventsSocket _eventsSocket;
  final GamePlayerRepository _playerRepository;
  final GameBoardRepository _boardRepository;
  final GameInventoryRepository _inventoryRepository;

  GameSpawnEventsProjection({
    required GameEventsSocket eventsSocket,
    required GamePlayerRepository playerRepository,
    required GameBoardRepository boardRepository,
    required GameInventoryRepository inventoryRepository,
  }) : _eventsSocket = eventsSocket,
       _playerRepository = playerRepository,
       _boardRepository = boardRepository,
       _inventoryRepository = inventoryRepository;

  @override
  List<StreamSubscription> subscribe() => [
    _eventsSocket.playerSpawnedStream.listen(_onPlayerSpawned),
  ];

  void _onPlayerSpawned(PlayerSpawnedEvent event) {
    _playerRepository.applyPlayersSpawned(event);
    _boardRepository.applyPlayersSpawned(event);
    _inventoryRepository.applyPlayersSpawned(event);
  }
}
