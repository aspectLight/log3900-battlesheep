import 'package:fpdart/fpdart.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../core/enums/board_interaction_mode.dart';
import '../../../../core/enums/item_type.dart';
import '../../../../core/helpers/functional_programming.dart';
import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../domain/models/game_board_position.dart';
import '../repositories/game_board_interaction_repository.dart';
import '../repositories/game_board_repository.dart';
import '../repositories/game_inventory_repository.dart';
import '../../domain/commands/game_movement_commands.dart';
import '../repositories/game_player_movement_repository.dart';

class GameMovementSideEffect with DisposableSideEffect {
  final String _roomId;
  final String _socketId;
  final GameBoardRepository _boardRepository;
  final GameBoardInteractionRepository _interactionRepository;
  final GameInventoryRepository _inventoryRepository;
  final GamePlayerMovementRepository _movementRepository;

  Option<GameBoardPosition> _lastRequestedPosition = const Option.none();

  GameMovementSideEffect({
    required String roomId,
    required String socketId,
    required GameBoardRepository boardRepository,
    required GameBoardInteractionRepository interactionRepository,
    required GameInventoryRepository inventoryRepository,
    required GamePlayerMovementRepository movementRepository,
  }) : _roomId = roomId,
       _socketId = socketId,
       _boardRepository = boardRepository,
       _interactionRepository = interactionRepository,
       _inventoryRepository = inventoryRepository,
       _movementRepository = movementRepository {
    trackEffect(_requestMovementsOnPositionChange);
  }

  late final _currentPosition = computed<Option<GameBoardPosition>>(
    () => Option.fromNullable(
      _boardRepository.state.value.playerPositions[_socketId],
    ),
  );

  void _requestMovementsOnPositionChange() {
    if (_interactionRepository.state.value != BoardInteractionMode.selection) {
      _lastRequestedPosition = const Option.none();
      return;
    }
    _currentPosition.value.whenPresent((position) {
      if (_lastRequestedPosition.contains(position)) return;
      _lastRequestedPosition = Option.of(position);
      _requestReachableCells();
    });
  }

  void _requestReachableCells() {
    final inventory =
        _inventoryRepository.state.value.itemsByPlayerId[_socketId] ?? [];
    _movementRepository.getMovements(
      PlayerGetMovementsCommand(
        roomId: _roomId,
        hasBoots: inventory.any(
          (item) => item.type == ItemType.waterproofBoots,
        ),
      ),
    );
  }
}
