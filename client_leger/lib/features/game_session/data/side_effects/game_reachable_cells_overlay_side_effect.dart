import '../../../../core/enums/item_type.dart';
import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../core/event_bus/game_session_event_bus.dart';
import '../../domain/commands/game_movement_commands.dart';
import '../../domain/events/game_debug_events.dart';
import '../../domain/events/game_events.dart';
import '../../domain/events/game_movement_events.dart';
import '../repositories/game_board_repository.dart';
import '../repositories/game_debug_repository.dart';
import '../repositories/game_inventory_repository.dart';
import '../repositories/game_player_movement_repository.dart';
import '../repositories/game_turn_repository.dart';

class GameReachableCellsOverlaySideEffect with DisposableSideEffect {
  final String _roomId;
  final String _socketId;
  final GameSessionEventBus _gameSessionEventBus;
  final GameBoardRepository _boardRepository;
  final GameDebugRepository _debugRepository;
  final GamePlayerMovementRepository _movementRepository;
  final GameInventoryRepository _inventoryRepository;
  final GameTurnRepository _turnRepository;

  GameReachableCellsOverlaySideEffect({
    required String roomId,
    required String socketId,
    required GameSessionEventBus gameSessionEventBus,
    required GameBoardRepository boardRepository,
    required GameDebugRepository debugRepository,
    required GamePlayerMovementRepository movementRepository,
    required GameInventoryRepository inventoryRepository,
    required GameTurnRepository turnRepository,
  })  : _roomId = roomId,
        _socketId = socketId,
        _gameSessionEventBus = gameSessionEventBus,
        _boardRepository = boardRepository,
        _debugRepository = debugRepository,
        _movementRepository = movementRepository,
        _inventoryRepository = inventoryRepository,
        _turnRepository = turnRepository {
    trackSubscription(
        _gameSessionEventBus.on<TurnStartingEvent>().listen(_onTurnStarting));
    trackSubscription(_gameSessionEventBus
        .on<DebugModeEnabledEvent>()
        .listen(_onDebugModeEnabled));
    trackSubscription(_gameSessionEventBus
        .on<DebugModeDisabledEvent>()
        .listen(_onDebugModeDisabled));
    trackSubscription(
        _gameSessionEventBus.on<PlayerMoveCompleted>().listen(_onPlayerMoveCompleted));
    trackSubscription(_gameSessionEventBus
        .on<PlayerTeleportedEvent>()
        .listen(_onPlayerTeleported));
    trackSubscription(_gameSessionEventBus
        .on<PlayerAbandonedWithSpawnPoint>()
        .listen(_onPlayerAbandoned));
    trackSubscription(
        _gameSessionEventBus.on<DoorToggledEvent>().listen(_onDoorToggled));
    trackSubscription(_gameSessionEventBus
        .on<ReachablePathsResponseEvent>()
        .listen(_onReachablePathsResponse));
  }

  void _onReachablePathsResponse(ReachablePathsResponseEvent event) {
    if (_debugRepository.state.value.isDebugMode) {
      _boardRepository.clearReachablePaths();
    }
  }

  void _onTurnStarting(TurnStartingEvent event) {
    _boardRepository.clearReachablePaths();
    _boardRepository.setSelectedPath([]);
    if (event.nextPlayerId != _socketId) return;
    if (_debugRepository.state.value.isDebugMode) return;
    _requestGetPlayerMovements();
  }

  void _onDebugModeEnabled(DebugModeEnabledEvent event) {
    _boardRepository.clearReachablePaths();
  }

  void _onPlayerMoveCompleted(PlayerMoveCompleted event) {
    if (event.event.playerId != _socketId) return;
    _requestGetPlayerMovements();
  }

  void _onPlayerTeleported(PlayerTeleportedEvent event) {
    if (event.playerId != _socketId) return;
    if (_debugRepository.state.value.isDebugMode) return;
    _requestGetPlayerMovements();
  }

  void _onPlayerAbandoned(PlayerAbandonedWithSpawnPoint event) {
    if (_turnRepository.state.value.currentPlayerId != _socketId) return;
    _requestGetPlayerMovements();
  }

  void _onDoorToggled(DoorToggledEvent event) {
    _requestGetPlayerMovements();
    if (_debugRepository.state.value.isDebugMode) {
      _boardRepository.clearReachablePaths();
    }
  }

  void _onDebugModeDisabled(DebugModeDisabledEvent event) {
    _requestGetPlayerMovements();
  }

  void _requestGetPlayerMovements() {
    if (_turnRepository.state.value.currentPlayerId != _socketId) return;
    final inventory =
        _inventoryRepository.state.value.itemsByPlayerId[_socketId] ?? [];
    final hasBoots =
        inventory.any((item) => item.type == ItemType.waterproofBoots);
    _movementRepository.getMovements(
      PlayerGetMovementsCommand(roomId: _roomId, hasBoots: hasBoots),
    );
  }
}
