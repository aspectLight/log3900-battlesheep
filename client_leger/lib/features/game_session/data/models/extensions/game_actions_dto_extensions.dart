import '../../../domain/commands/game_action_commands.dart';
import '../dto/game_actions_dto.dart';

extension ForwardTurnCommandToDto on ForwardTurnCommand {
  ForwardTurnCommandDto toDto() => ForwardTurnCommandDto(roomId: roomId);
}

extension AbandonGameCommandToDto on AbandonGameCommand {
  AbandonGameCommandDto toDto() => AbandonGameCommandDto(roomId: roomId);
}

extension QuitEndGameCommandToDto on QuitEndGameCommand {
  QuitEndGameCommandDto toDto() => QuitEndGameCommandDto(roomId: roomId);
}

extension VirtualPlayerTurnCommandToDto on VirtualPlayerTurnCommand {
  VirtualPlayerTurnCommandDto toDto() => VirtualPlayerTurnCommandDto(
        roomId: roomId,
        playerId: playerId,
        isCTF: isCTF,
        skipTimeout: skipTimeout,
      );
}

extension FinishGameCommandToDto on FinishGameCommand {
  FinishGameCommandDto toDto() =>
      FinishGameCommandDto(roomId: roomId, winnerId: winnerId);
}
