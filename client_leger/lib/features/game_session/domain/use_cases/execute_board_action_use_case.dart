import '../../core/enums/board_interaction_mode.dart';
import '../../../../core/enums/item_type.dart';
import '../commands/game_combat_commands.dart';
import '../commands/game_door_commands.dart';
import '../commands/game_movement_commands.dart';
import '../models/tile.dart';
import '../models/game_board_position.dart';
import '../../data/repositories/game_board_interaction_repository.dart';
import '../../data/repositories/game_board_repository.dart';
import '../../data/repositories/game_combat_repository.dart';
import '../../data/repositories/game_inventory_repository.dart';
import '../../data/repositories/game_player_movement_repository.dart';
import '../../data/repositories/game_player_repository.dart';
import '../state/game_board_state.dart';

class ExecuteBoardActionUseCase {
  final String _roomId;
  final String _socketId;
  final GameBoardRepository _boardRepository;
  final GameCombatRepository _combatRepository;
  final GameBoardInteractionRepository _interactionRepository;
  final GamePlayerRepository _playerRepository;
  final GamePlayerMovementRepository _movementRepository;
  final GameInventoryRepository _inventoryRepository;

  ExecuteBoardActionUseCase({
    required String roomId,
    required String socketId,
    required GameBoardRepository boardRepository,
    required GameCombatRepository combatRepository,
    required GameBoardInteractionRepository interactionRepository,
    required GamePlayerRepository playerRepository,
    required GamePlayerMovementRepository movementRepository,
    required GameInventoryRepository inventoryRepository,
  }) : _roomId = roomId,
       _socketId = socketId,
       _boardRepository = boardRepository,
       _combatRepository = combatRepository,
       _interactionRepository = interactionRepository,
       _playerRepository = playerRepository,
       _movementRepository = movementRepository,
       _inventoryRepository = inventoryRepository;

  void execute(int x, int y) {
    final boardState = _boardRepository.state.value;
    final board = boardState.board;
    _executeOnCell(board.matrix[x][y], boardState, _roomId);
    _advanceInteractionMode();
  }

  void _advanceInteractionMode() {
    if (_interactionRepository.state.value == BoardInteractionMode.selection) {
      _interactionRepository.enterActionMode();
    } else {
      _interactionRepository.enterSelectionMode();
    }
  }

  void _executeOnCell(
    BoardCell cell,
    GameBoardState boardState,
    String roomId,
  ) {
    final pos = GameBoardPosition(x: cell.x, y: cell.y);
    final playerPos = boardState.playerPositions[_socketId];
    String? opponentId;
    for (final e in boardState.playerPositions.entries) {
      if (e.value.x == pos.x && e.value.y == pos.y) {
        opponentId = e.key;
        break;
      }
    }
    if (_isTeleportPadPartner(cell, boardState)) {
      _movementRepository.teleportPlayer(
        PlayerTeleportedCommand(
          roomId: roomId,
          playerId: _socketId,
          destination: pos,
          hasCamouflage: false,
        ),
      );
      _playerRepository.decrementActionPointsForPlayer(_socketId);
      return;
    }
    final isAdjacent =
        playerPos != null &&
        ((playerPos.x - pos.x).abs() == 1 && playerPos.y == pos.y ||
            (playerPos.y - pos.y).abs() == 1 && playerPos.x == pos.x);
    if (!isAdjacent) {
      _executeRemoteOnCell(
        cell: cell,
        roomId: roomId,
        targetPosition: pos,
        opponentId: opponentId,
      );
      return;
    }
    if (cell.tile is DoorTile) {
      _boardRepository.toggleDoor(
        ToggleDoorCommand(roomId: roomId, x: cell.x, y: cell.y),
      );
      _playerRepository.decrementActionPointsForPlayer(_socketId);
      return;
    }
    if (opponentId != null && opponentId.isNotEmpty) {
      _combatRepository.startCombat(
        StartCombatCommand(roomId: roomId, opponentId: opponentId),
      );
      _playerRepository.decrementActionPointsForPlayer(_socketId);
    }
  }

  void _executeRemoteOnCell({
    required BoardCell cell,
    required String roomId,
    required GameBoardPosition targetPosition,
    required String? opponentId,
  }) {
    final items = _inventoryRepository.state.value.getItems(_socketId);
    final hasAirStrike = items.any((item) => item.type == ItemType.airStrike);
    final hasCamouflage = items.any((item) => item.type == ItemType.camouflage);
    if (opponentId != null && opponentId.isNotEmpty && hasAirStrike) {
      _combatRepository.startCombat(
        StartCombatCommand(roomId: roomId, opponentId: opponentId),
      );
      _playerRepository.decrementActionPointsForPlayer(_socketId);
      return;
    }
    if (hasCamouflage) {
      _movementRepository.teleportPlayer(
        PlayerTeleportedCommand(
          roomId: roomId,
          playerId: _socketId,
          destination: targetPosition,
          hasCamouflage: true,
        ),
      );
      _playerRepository.decrementActionPointsForPlayer(_socketId);
    }
  }

  bool _isTeleportPadPartner(BoardCell targetCell, GameBoardState boardState) {
    final playerPos = boardState.playerPositions[_socketId];
    if (playerPos == null) {
      return false;
    }

    final playerCell = boardState.board.matrix[playerPos.x][playerPos.y];
    final playerTile = playerCell.tile;
    final targetTile = targetCell.tile;

    if (playerTile is! TeleportPadTile || targetTile is! TeleportPadTile) {
      return false;
    }

    if (playerTile.state != targetTile.state) {
      return false;
    }

    if (playerPos.x == targetCell.x && playerPos.y == targetCell.y) {
      return false;
    }

    final hasPlayerOnTarget = boardState.playerPositions.values.any(
      (position) => position.x == targetCell.x && position.y == targetCell.y,
    );
    return !hasPlayerOnTarget;
  }
}
