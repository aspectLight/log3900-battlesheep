import '../../data/repositories/game_board_repository.dart';
import '../../data/repositories/game_debug_repository.dart';
import '../../data/repositories/game_player_movement_repository.dart';
import '../../data/repositories/game_turn_repository.dart';
import '../commands/game_movement_commands.dart';
import '../models/game_board_position.dart';

class DebugTeleportPlayerUseCase {
  final String _roomId;
  final String _socketId;
  final GameDebugRepository _debugRepository;
  final GameTurnRepository _turnRepository;
  final GameBoardRepository _boardRepository;
  final GamePlayerMovementRepository _movementRepository;

  DebugTeleportPlayerUseCase({
    required String roomId,
    required String socketId,
    required GameDebugRepository debugRepository,
    required GameTurnRepository turnRepository,
    required GameBoardRepository boardRepository,
    required GamePlayerMovementRepository movementRepository,
  }) : _roomId = roomId,
       _socketId = socketId,
       _debugRepository = debugRepository,
       _turnRepository = turnRepository,
       _boardRepository = boardRepository,
       _movementRepository = movementRepository;

  bool execute(int x, int y) {
    if (!_canTeleport(x, y, _socketId)) return false;
    _movementRepository.teleportPlayer(
      PlayerTeleportedCommand(
        roomId: _roomId,
        playerId: _socketId,
        destination: GameBoardPosition(x: x, y: y),
        hasCamouflage: false,
      ),
    );
    return true;
  }

  bool _canTeleport(int x, int y, String socketId) {
    final isDebug = _debugRepository.state.value.isDebugMode;
    if (!isDebug) return false;
    final isMyTurn = _turnRepository.state.value.isCurrentSessionPlayerTurn(
      socketId,
    );
    if (!isMyTurn) return false;
    final boardState = _boardRepository.state.value;
    final board = boardState.board;
    if (!board.isInBounds(x, y)) return false;
    return board.matrix[x][y].isEmpty(boardState);
  }
}
