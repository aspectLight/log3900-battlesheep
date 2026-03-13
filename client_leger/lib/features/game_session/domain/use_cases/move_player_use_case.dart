import '../commands/game_movement_commands.dart';
import '../../data/repositories/game_board_repository.dart';
import '../../data/repositories/game_player_movement_repository.dart';
import '../../data/repositories/game_turn_repository.dart';

class MovePlayerUseCase {
  final String _roomId;
  final GameTurnRepository _turnRepository;
  final GameBoardRepository _boardRepository;
  final GamePlayerMovementRepository _movementRepository;

  MovePlayerUseCase({
    required String roomId,
    required GameTurnRepository turnRepository,
    required GameBoardRepository boardRepository,
    required GamePlayerMovementRepository movementRepository,
  }) : _roomId = roomId,
       _turnRepository = turnRepository,
       _boardRepository = boardRepository,
       _movementRepository = movementRepository;

  void execute() {
    final turnState = _turnRepository.state.value;
    final boardState = _boardRepository.state.value;
    _movementRepository.movePlayer(
      PlayerMovedCommand(
        roomId: _roomId,
        playerId: turnState.currentPlayerId,
        selectedPath: boardState.selectedPathCoords,
      ),
    );
  }
}
