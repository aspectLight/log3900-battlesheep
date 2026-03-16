import 'package:signals_flutter/signals_flutter.dart';

import '../../../core/enums/board_interaction_mode.dart';
import '../../../data/repositories/game_board_interaction_repository.dart';
import '../../../data/repositories/game_board_repository.dart';
import '../../../data/repositories/game_board_selected_cell_repository.dart';
import '../../../data/repositories/game_debug_repository.dart';
import '../../../data/repositories/game_player_repository.dart';
import '../../../data/repositories/game_turn_repository.dart';
import '../../../domain/models/game_board_cell_selection.dart';
import '../../../domain/models/game_board_position.dart';
import '../../../domain/use_cases/debug_teleport_player_use_case.dart';
import '../../../domain/use_cases/execute_board_action_use_case.dart';
import '../../../domain/use_cases/move_player_use_case.dart';
import '../../mappers/game_board_cell_ui_mapper.dart';
import '../../ui_models/components/game_board_cell_ui.dart';
import '../../ui_models/components/game_board_ui.dart';

class GameBoardViewModel {
  final GameBoardSelectedCellRepository _gameBoardSelectedCellRepository;
  final GameBoardRepository _boardRepository;
  final GamePlayerRepository _playerRepository;
  final GameTurnRepository _turnRepository;
  final GameBoardInteractionRepository _interactionRepository;
  final GameDebugRepository _debugRepository;
  final ExecuteBoardActionUseCase _executeBoardActionUseCase;
  final MovePlayerUseCase _movePlayerUseCase;
  final DebugTeleportPlayerUseCase _debugTeleportPlayerUseCase;

  late final board = computed<GameBoardUi>(() {
    final boardState = _boardRepository.state.value;
    final b = boardState.board;
    final playerState = _playerRepository.state.value;
    return toGameBoardUi(b, playerState, boardState);
  });

  late final selection = computed<GameBoardCellSelection>(
    () => _gameBoardSelectedCellRepository.state.value,
  );

  late final reachableCellCoords = computed<Set<GameBoardPosition>>(() {
    final boardState = _boardRepository.state.value;
    final raw = boardState.reachableCellCoords;
    final currentPlayerId = _turnRepository.state.value.currentPlayerId;
    final currentPos = boardState.playerPositions[currentPlayerId];
    if (currentPos == null) return raw;
    return raw.where((p) => p.x != currentPos.x || p.y != currentPos.y).toSet();
  });

  late final reachablePathsByDestination =
      computed<Map<GameBoardPosition, List<GameBoardPosition>>>(() {
        return _boardRepository.state.value.reachablePathsByDestination;
      });

  late final movementPathCoords = computed<Set<GameBoardPosition>>(() {
    return Set<GameBoardPosition>.from(
      _boardRepository.state.value.selectedPathCoords,
    );
  });

  late final selectedPathOrdered = computed<List<GameBoardPosition>>(() {
    return _boardRepository.state.value.selectedPathCoords;
  });

  late final interactionMode = computed(
    () => _interactionRepository.state.value,
  );

  late final isSelectionActive = computed(
    () => interactionMode.value == BoardInteractionMode.selection,
  );

  late final isInActionMode = computed(
    () => interactionMode.value == BoardInteractionMode.action,
  );

  late final isMoving = computed(
    () => interactionMode.value == BoardInteractionMode.moving,
  );

  GameBoardViewModel({
    required GameBoardSelectedCellRepository gameBoardSelectedCellRepository,
    required GameBoardRepository boardRepository,
    required GamePlayerRepository playerRepository,
    required GameTurnRepository turnRepository,
    required GameBoardInteractionRepository interactionRepository,
    required GameDebugRepository debugRepository,
    required ExecuteBoardActionUseCase executeBoardActionUseCase,
    required MovePlayerUseCase movePlayerUseCase,
    required DebugTeleportPlayerUseCase debugTeleportPlayerUseCase,
  }) : _gameBoardSelectedCellRepository = gameBoardSelectedCellRepository,
       _boardRepository = boardRepository,
       _playerRepository = playerRepository,
       _turnRepository = turnRepository,
       _interactionRepository = interactionRepository,
       _debugRepository = debugRepository,
       _executeBoardActionUseCase = executeBoardActionUseCase,
       _movePlayerUseCase = movePlayerUseCase,
       _debugTeleportPlayerUseCase = debugTeleportPlayerUseCase;

  void handleCellLongPress(GameBoardCellUi cell) {
    _debugTeleportPlayerUseCase.execute(cell.x, cell.y);
  }

  void handleCellPrimaryTap(GameBoardCellUi cell) {
    if (isMoving.value) return;
    _gameBoardSelectedCellRepository.setSelectedCell(cell.x, cell.y);
    if (isInActionMode.value) {
      _executeBoardActionUseCase.execute(cell.x, cell.y);
      return;
    }
    if (isSelectionActive.value) {
      if (_debugRepository.state.value.isDebugMode) {
        _boardRepository.setSelectedPath([]);
        return;
      }
      final pos = GameBoardPosition(x: cell.x, y: cell.y);
      final reachable = reachableCellCoords.value;
      if (!reachable.contains(pos)) {
        _boardRepository.setSelectedPath([]);
        return;
      }
      final path = reachablePathsByDestination.value[pos];
      if (path == null || path.isEmpty) return;
      final currentPath = _boardRepository.state.value.selectedPathCoords;
      final isSecondTapOnSameTile = currentPath.isNotEmpty &&
          currentPath.last.x == pos.x &&
          currentPath.last.y == pos.y;
      if (isSecondTapOnSameTile) {
        _movePlayerUseCase.execute();
        return;
      }
      _boardRepository.setSelectedPath(path);
    }
  }

  void handleCellSecondaryTap(GameBoardCellUi cell) {
    if (isMoving.value) return;
    _gameBoardSelectedCellRepository.setSelectedCell(cell.x, cell.y);
    _interactionRepository.toggleSelectionMode();
  }

  void dispose() {}
}
