import 'package:fpdart/fpdart.dart';

import '../../../../core/helpers/functional_programming.dart';
import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../core/event_bus/game_session_event_bus.dart';
import '../../data/repositories/game_actions_repository.dart';
import '../../data/repositories/game_combat_repository.dart';
import '../../data/repositories/game_inventory_repository.dart';
import '../../data/repositories/game_item_repository.dart';
import '../../data/repositories/game_metadata_repository.dart';
import '../../domain/commands/game_action_commands.dart';
import '../../domain/commands/game_combat_commands.dart';
import '../../domain/commands/game_item_commands.dart';
import '../../domain/events/game_item_events.dart';
import '../../domain/events/game_movement_events.dart';
import '../../domain/models/game_board_position.dart';
import '../../domain/models/game_item.dart';
import '../../domain/state/game_session_state.dart';

class GameVirtualPlayerMoveSideEffect with DisposableSideEffect {
  final String _roomId;
  final String _socketId;
  final GameMetadataRepository _gameMetadataRepository;
  final GameActionsRepository _actionsRepository;
  final GameCombatRepository _combatRepository;
  final GameItemRepository _itemRepository;
  final GameInventoryRepository _inventoryRepository;

  GameVirtualPlayerMoveSideEffect({
    required String roomId,
    required String socketId,
    required GameSessionEventBus gameSessionEventBus,
    required GameMetadataRepository gameMetadataRepository,
    required GameActionsRepository actionsRepository,
    required GameCombatRepository combatRepository,
    required GameItemRepository itemRepository,
    required GameInventoryRepository inventoryRepository,
  }) : _roomId = roomId,
       _socketId = socketId,
       _gameMetadataRepository = gameMetadataRepository,
       _actionsRepository = actionsRepository,
       _combatRepository = combatRepository,
       _itemRepository = itemRepository,
       _inventoryRepository = inventoryRepository {
    trackSubscription(
      gameSessionEventBus.on<VirtualPlayerMoveCompleted>().listen(
        _onVirtualPlayerMoveCompleted,
      ),
    );
  }

  void _onVirtualPlayerMoveCompleted(VirtualPlayerMoveCompleted ev) {
    final metadata = _gameMetadataRepository.state.value;
    if (metadata is! GameSessionActive) return;

    final event = ev.event;

    _collectItemIfHost(
      metadata: metadata,
      event: event,
      destination: Option.Do(
        ($) =>
            (position: $(ev.destinationPosition), item: $(ev.destinationItem)),
      ),
    );

    if (event.opponentPlayerId.isNotEmpty) {
      _combatRepository.startVirtualCombat(
        StartVirtualCombatCommand(
          roomId: _roomId,
          playerId: event.playerId,
          opponentId: event.opponentPlayerId,
        ),
      );
      return;
    }

    if (event.remainingMovementPoints > 0) {
      _actionsRepository.runVirtualPlayerTurn(
        VirtualPlayerTurnCommand(
          roomId: _roomId,
          playerId: event.playerId,
          isCTF: metadata.isCTF,
          skipTimeout: true,
        ),
      );
      return;
    }

    final isHost = _socketId == metadata.hostId;
    if (isHost) {
      _actionsRepository.forwardTurn(ForwardTurnCommand(roomId: _roomId));
    }
  }

  void _collectItemIfHost({
    required GameSessionActive metadata,
    required VirtualPlayerMovedEvent event,
    required Option<({GameBoardPosition position, GameItem item})> destination,
  }) {
    if (_socketId != metadata.hostId) return;
    destination.whenPresent((dest) {
      _itemRepository.collectItem(
        ItemCollectedCommand(
          roomId: _roomId,
          playerId: event.playerId,
          item: dest.item,
          position: dest.position,
        ),
      );
      _inventoryRepository.applyItemCollected(
        ItemCollectedEvent(playerId: event.playerId, item: dest.item),
      );
    });
  }
}
