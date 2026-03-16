import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/app_transition/app_transition_bus.dart';
import '../../../core/app_events/game_session_events.dart';
import '../../../core/context/game_session_data.dart';
import '../../../core/enums/player_leave_reason.dart';
import '../../../domain/commands/game_action_commands.dart';
import '../../../data/repositories/game_actions_repository.dart';
import '../../../data/repositories/game_board_repository.dart';
import '../../../data/repositories/game_metadata_repository.dart';
import '../../../data/repositories/game_player_repository.dart';
import '../../../data/repositories/game_turn_repository.dart';
import '../../../domain/state/game_session_state.dart';
import '../../mappers/game_info_ui_mapper.dart';
import '../../ui_models/components/game_info_ui.dart';

class GameInfoPanelViewModel {
  final AppTransitionEventBus _appTransitionEventBus;
  final GameSessionData _sessionData;
  final GameActionsRepository _actionsRepository;
  final GameBoardRepository _boardRepository;
  final GamePlayerRepository _playerRepository;
  final GameTurnRepository _turnRepository;
  final GameMetadataRepository _metadataRepository;

  late final canForwardTurn = computed<bool>(
    () => _turnRepository.state.value.canForwardTurn,
  );

  late final infoModel = computed<GameInfoUi>(() {
    final playerState = _playerRepository.state.value;
    final turnState = _turnRepository.state.value;
    final boardState = _boardRepository.state.value;
    return toGameInfo(
      playerState,
      turnState,
      boardState,
      gameName: _sessionData.gameName,
      gameDescription: _sessionData.gameDescription,
    );
  });

  GameInfoPanelViewModel({
    required AppTransitionEventBus appTransitionEventBus,
    required GameSessionData sessionData,
    required GameActionsRepository actionsRepository,
    required GameBoardRepository boardRepository,
    required GamePlayerRepository playerRepository,
    required GameTurnRepository turnRepository,
    required GameMetadataRepository metadataRepository,
  }) : _appTransitionEventBus = appTransitionEventBus,
       _sessionData = sessionData,
       _actionsRepository = actionsRepository,
       _boardRepository = boardRepository,
       _playerRepository = playerRepository,
       _turnRepository = turnRepository,
       _metadataRepository = metadataRepository;

  void forwardTurn() {
    if (!canForwardTurn.value) return;
    final meta = _metadataRepository.state.value;
    if (meta is! GameSessionActive) return;
    _actionsRepository.forwardTurn(ForwardTurnCommand(roomId: meta.roomId));
  }

  Future<void> leaveGame() async {
    final meta = _metadataRepository.state.value;
    if (meta is! GameSessionActive) return;
    _actionsRepository.abandonGame(AbandonGameCommand(roomId: meta.roomId));
    _appTransitionEventBus.fire(
      const GameSessionExitAppEvent.leaveRequested(PlayerLeaveReason.abandoned),
    );
  }

  void dispose() {}
}
