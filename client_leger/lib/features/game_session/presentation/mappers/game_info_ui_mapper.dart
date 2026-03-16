import '../../../../core/helpers/functional_programming.dart';
import '../../domain/state/game_board_state.dart';
import '../../domain/state/game_player_state.dart';
import '../../domain/state/game_turn_state.dart';
import '../ui_models/components/game_info_ui.dart';

GameInfoUi toGameInfo(
  GamePlayerState playerState,
  GameTurnState turnState,
  GameBoardState boardState, {
  required String gameName,
  required String gameDescription,
}) {
  final activePlayerName = playerState
      .findById(turnState.currentPlayerId)
      .map((p) => p.name)
      .orElse('');
  return GameInfoUi(
    gameName: gameName,
    gameDescription: gameDescription,
    playerCount: playerState.players.length,
    activePlayerName: activePlayerName,
    boardSize: boardState.board.size,
  );
}
