import '../../../../core/helpers/functional_programming.dart';
import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../core/event_bus/game_session_event_bus.dart';
import '../../domain/events/game_events.dart';
import '../repositories/game_board_repository.dart';
import '../repositories/game_inventory_repository.dart';

class GamePlayerAbandonedBoardSideEffect with DisposableSideEffect {
  GamePlayerAbandonedBoardSideEffect({
    required GameSessionEventBus gameSessionEventBus,
    required GameBoardRepository boardRepository,
    required GameInventoryRepository inventoryRepository,
  }) : _gameSessionEventBus = gameSessionEventBus,
       _boardRepository = boardRepository,
       _inventoryRepository = inventoryRepository {
    trackSubscription(
      _gameSessionEventBus.on<PlayerAbandonedWithSpawnPoint>().listen(
        _onPlayerAbandonedWithSpawnPoint,
      ),
    );
  }

  final GameSessionEventBus _gameSessionEventBus;
  final GameBoardRepository _boardRepository;
  final GameInventoryRepository _inventoryRepository;

  void _onPlayerAbandonedWithSpawnPoint(PlayerAbandonedWithSpawnPoint e) {
    _boardRepository.clearPendingItemPickupIfPlayer(e.playerId);
    e.spawnPoint.whenPresent(
      (position) => _boardRepository.applySpawnPointCleared(
        SpawnPointClearedEvent(position: position),
      ),
    );
    _boardRepository.removePlayerFromBoard(e.playerId);
    _inventoryRepository.removePlayerItems(e.playerId);
  }
}
