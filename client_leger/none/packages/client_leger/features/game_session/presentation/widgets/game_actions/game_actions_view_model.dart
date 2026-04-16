import 'package:signals_flutter/signals_flutter.dart';

import '../../../core/enums/board_interaction_mode.dart';
import '../../../data/repositories/game_board_interaction_repository.dart';
import '../../../data/repositories/game_board_repository.dart';
import '../../../data/repositories/game_turn_repository.dart';
import '../../../domain/state/game_turn_state.dart';
import '../../../domain/use_cases/forward_turn_use_case.dart';

class GameActionsViewModel {
  final GameTurnRepository _turnRepository;
  final GameBoardInteractionRepository _interactionRepository;
  final GameBoardRepository _boardRepository;
  final ForwardTurnUseCase _forwardTurnUseCase;
  final String _socketId;

  GameActionsViewModel({
    required GameTurnRepository turnRepository,
    required GameBoardInteractionRepository interactionRepository,
    required GameBoardRepository boardRepository,
    required ForwardTurnUseCase forwardTurnUseCase,
    required String socketId,
  }) : _turnRepository = turnRepository,
       _interactionRepository = interactionRepository,
       _boardRepository = boardRepository,
       _forwardTurnUseCase = forwardTurnUseCase,
       _socketId = socketId;

  GameTurnState get _turnState => _turnRepository.state.value;

  late final isCurrentPlayerTurn = computed<bool>(
    () => _turnRepository.state.value.currentPlayerId == _socketId,
  );

  late final isInActionMode = computed<bool>(
    () => _interactionRepository.state.value == BoardInteractionMode.action,
  );

  late final canForwardTurn = computed<bool>(() => _turnState.canForwardTurn);

  void toggleActionModeOrReturnToSelection() {
    if (!isCurrentPlayerTurn.value) return;
    if (_interactionRepository.state.value == BoardInteractionMode.selection) {
      _boardRepository.setSelectedPath([]);
    }
    _interactionRepository.toggleActionModeOrReturnToSelection();
  }

  void forwardTurn() {
    if (!canForwardTurn.value) return;
    _forwardTurnUseCase.execute();
  }
}
