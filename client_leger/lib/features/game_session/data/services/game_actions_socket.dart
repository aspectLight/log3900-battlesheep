import '../models/extensions/game_actions_dto_extensions.dart';
import '../models/events/game_action_socket_events.dart';
import '../../domain/commands/game_action_commands.dart';
import '../../../../core/services/socket_service.dart';

class GameActionsSocket {
  final SocketService _socketService;

  GameActionsSocket({required SocketService socketService})
    : _socketService = socketService;

  void abandonGame(AbandonGameCommand command) {
    _socketService.emit(GameActionSocketEvents.abandonGame, command.roomId);
  }

  void forwardTurn(ForwardTurnCommand command) {
    _socketService.emit(GameActionSocketEvents.forwardTurn, command.roomId);
  }

  void quitEndGame(QuitEndGameCommand command) {
    _socketService.emit(GameActionSocketEvents.quitEndGame, command.roomId);
  }

  void runVirtualPlayerTurn(VirtualPlayerTurnCommand command) {
    _socketService.emit(
      GameActionSocketEvents.virtualPlayerTurn,
      command.toDto().toJson(),
    );
  }

  void finishGame(FinishGameCommand command) {
    _socketService.emit(
      GameActionSocketEvents.finishGame,
      command.toDto().toJson(),
    );
  }

  Future<void> dispose() async {}
}
