import 'dart:async';

import '../../../../core/interfaces/event_projection.dart';
import '../../core/event_bus/game_session_event_bus.dart';
import '../../core/helpers/can_player_move_or_act.dart';
import '../../domain/events/game_movement_events.dart';
import '../models/dto/game_trap_torch_dto.dart';
import '../models/extensions/game_trap_torch_dto_extensions.dart';
import '../repositories/game_board_repository.dart';
import '../repositories/game_metadata_repository.dart';
import '../repositories/game_player_repository.dart';
import '../repositories/game_turn_repository.dart';
import '../services/game_player_movement_socket.dart';

class GameMovementEventsProjection implements EventProjection {
  final GamePlayerMovementSocket _movementSocket;
  final GameBoardRepository _boardRepository;
  final GamePlayerRepository _playerRepository;
  final GameTurnRepository _turnRepository;
  final GameMetadataRepository _metadataRepository;
  final GameSessionEventBus _gameSessionEventBus;

  GameMovementEventsProjection({
    required GamePlayerMovementSocket movementSocket,
    required GameBoardRepository boardRepository,
    required GamePlayerRepository playerRepository,
    required GameTurnRepository turnRepository,
    required GameMetadataRepository metadataRepository,
    required GameSessionEventBus gameSessionEventBus,
  }) : _movementSocket = movementSocket,
       _boardRepository = boardRepository,
       _playerRepository = playerRepository,
       _turnRepository = turnRepository,
       _metadataRepository = metadataRepository,
       _gameSessionEventBus = gameSessionEventBus;

  @override
  List<StreamSubscription> subscribe() => [
    _movementSocket.reachablePathsResponseStream.listen(
      _onReachablePathsResponse,
    ),
    _movementSocket.playerMovedStream.listen(_onPlayerMoved),
    _movementSocket.virtualPlayerMovedStream.listen(_onVirtualPlayerMoved),
    _movementSocket.playerTeleportedStream.listen(_onPlayerTeleported),
    _movementSocket.synchronizeMovementStream.listen(
      _boardRepository.applyMovementSync,
    ),
    _movementSocket.torchIlluminationStream.listen(_onTorchIllumination),
  ];

  void _onReachablePathsResponse(ReachablePathsResponseEvent event) {
    final currentPlayerId = _turnRepository.state.value.currentPlayerId;
    if (currentPlayerId.isNotEmpty &&
        !canPlayerMoveOrAct(
          currentPlayerId,
          _playerRepository.state.value,
          _boardRepository.state.value,
          _metadataRepository.state.value,
        )) {
      _boardRepository.clearReachablePaths();
      return;
    }
    _boardRepository.setReachablePathsFromResponse(event.paths);
    _gameSessionEventBus.fire(event);
  }

  void _onPlayerTeleported(PlayerTeleportedEvent event) {
    _boardRepository.applyPlayerTeleported(event);
    _gameSessionEventBus.fire(event);
  }

  void _onPlayerMoved(PlayerMovedEvent event) {
    _playerRepository.applyPlayerMoved(event);
    _gameSessionEventBus.fire(PlayerMoveCompleted(event));
  }

  void _onVirtualPlayerMoved(VirtualPlayerMovedEvent event) {
    _playerRepository.applyVirtualPlayerMoved(event);
    _gameSessionEventBus.fire(VirtualPlayerMoved(event));
  }

  void _onTorchIllumination(TorchIlluminationUpdateDto dto) {
    _boardRepository.applyIlluminationUpdate(dto.toBoardIlluminationEvent());
    _playerRepository.applyTorchPlayerStats(dto.toPlayerTorchStatsEvent());
  }
}
