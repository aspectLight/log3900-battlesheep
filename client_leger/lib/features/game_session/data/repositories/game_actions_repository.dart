import '../../domain/commands/game_action_commands.dart';
import '../services/game_actions_socket.dart';

class GameActionsRepository {
  final GameActionsSocket _actionsSocket;

  GameActionsRepository({required GameActionsSocket actionsSocket})
    : _actionsSocket = actionsSocket;

  void abandonGame(AbandonGameCommand command) {
    _actionsSocket.abandonGame(command);
  }

  void forwardTurn(ForwardTurnCommand command) {
    _actionsSocket.forwardTurn(command);
  }

  void quitEndGame(QuitEndGameCommand command) {
    _actionsSocket.quitEndGame(command);
  }

  void runVirtualPlayerTurn(VirtualPlayerTurnCommand command) {
    _actionsSocket.runVirtualPlayerTurn(command);
  }

  void finishGame(FinishGameCommand command) {
    _actionsSocket.finishGame(command);
  }
}
