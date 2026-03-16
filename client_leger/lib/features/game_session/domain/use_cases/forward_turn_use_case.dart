import '../../data/repositories/game_actions_repository.dart';
import '../../data/repositories/game_turn_repository.dart';
import '../commands/game_action_commands.dart';

class ForwardTurnUseCase {
  final String _roomId;
  final GameTurnRepository _turnRepository;
  final GameActionsRepository _actionsRepository;

  ForwardTurnUseCase({
    required String roomId,
    required GameTurnRepository turnRepository,
    required GameActionsRepository actionsRepository,
  }) : _roomId = roomId,
       _turnRepository = turnRepository,
       _actionsRepository = actionsRepository;

  void execute() {
    final turnState = _turnRepository.state.value;
    if (!turnState.canForwardTurn) return;
    _turnRepository.setCanForwardTurn(value: false);
    _actionsRepository.forwardTurn(ForwardTurnCommand(roomId: _roomId));
  }
}
