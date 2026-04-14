import 'dart:async';

import '../../../../core/enums/item_type.dart';
import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../../../core/notification/notification_coordinator.dart';
import '../../../../core/notification/notification_intent.dart';
import '../../core/helpers/can_player_move_or_act.dart';
import '../../domain/commands/game_action_commands.dart';
import '../../domain/commands/game_movement_commands.dart';
import '../../domain/events/game_environment_events.dart'
    show TrapPendingEvent, TrapResultSyncEvent;
import '../repositories/game_actions_repository.dart';
import '../repositories/game_board_repository.dart';
import '../repositories/game_inventory_repository.dart';
import '../repositories/game_metadata_repository.dart';
import '../repositories/game_player_movement_repository.dart';
import '../repositories/game_player_repository.dart';
import '../repositories/game_turn_repository.dart';

class GameTrapFlowSideEffect with DisposableSideEffect {
  final String _roomId;
  final String _socketId;
  final NotificationCoordinator _notificationCoordinator;
  final GameActionsRepository _actionsRepository;
  final GamePlayerMovementRepository _movementRepository;
  final GameBoardRepository _boardRepository;
  final GamePlayerRepository _playerRepository;
  final GameMetadataRepository _metadataRepository;
  final GameTurnRepository _turnRepository;
  final GameInventoryRepository _inventoryRepository;

  GameTrapFlowSideEffect({
    required String roomId,
    required String socketId,
    required NotificationCoordinator notificationCoordinator,
    required GameActionsRepository actionsRepository,
    required GamePlayerMovementRepository movementRepository,
    required GameBoardRepository boardRepository,
    required GamePlayerRepository playerRepository,
    required GameMetadataRepository metadataRepository,
    required GameTurnRepository turnRepository,
    required GameInventoryRepository inventoryRepository,
  }) : _roomId = roomId,
       _socketId = socketId,
       _notificationCoordinator = notificationCoordinator,
       _actionsRepository = actionsRepository,
       _movementRepository = movementRepository,
       _boardRepository = boardRepository,
       _playerRepository = playerRepository,
       _metadataRepository = metadataRepository,
       _turnRepository = turnRepository,
       _inventoryRepository = inventoryRepository {
    trackSubscription(
      _movementRepository.trapPendingStream.listen(_onTrapPending),
    );
    trackSubscription(
      _movementRepository.trapResultStream.listen(
        (e) => unawaited(_handleTrapResult(e)),
      ),
    );
  }

  void _onTrapPending(TrapPendingEvent event) {
    if (event.playerId != _socketId) return;
    _notificationCoordinator.addIntent(
      TrapChoiceIntent(
        canAvoid: event.canAvoid,
        onChoice: (choice) {
          _movementRepository.trapChoice(
            TrapChoiceCommand(
              roomId: _roomId,
              playerId: _socketId,
              choice: choice,
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleTrapResult(TrapResultSyncEvent event) async {
    _playerRepository.applyTrapResult(event);
    if (event.playerId != _socketId) return;
    if (_turnRepository.state.value.currentPlayerId != _socketId) return;
    if (event.activated) {
      _actionsRepository.forwardTurn(ForwardTurnCommand(roomId: _roomId));
      return;
    }
    final inv =
        _inventoryRepository.state.value.itemsByPlayerId[_socketId] ?? [];
    _movementRepository.getMovements(
      PlayerGetMovementsCommand(
        roomId: _roomId,
        hasBoots: inv.any((item) => item.type == ItemType.waterproofBoots),
      ),
    );
    await _movementRepository.reachablePathsResponseStream.first;
    if (!canPlayerMoveOrAct(
      _socketId,
      _playerRepository.state.value,
      _boardRepository.state.value,
      _metadataRepository.state.value,
    )) {
      _actionsRepository.forwardTurn(ForwardTurnCommand(roomId: _roomId));
    }
  }
}
