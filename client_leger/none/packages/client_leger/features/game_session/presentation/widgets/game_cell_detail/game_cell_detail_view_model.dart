import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/services/socket_service.dart';
import '../../../data/repositories/game_board_repository.dart';
import '../../../data/repositories/game_board_selected_cell_repository.dart';
import '../../../data/repositories/game_player_repository.dart';
import '../../mappers/game_cell_ui_detail_mapper.dart';
import '../../ui_models/widget_states/game_cell_detail_ui_state.dart';

class GameCellDetailWidgetViewModel {
  final GameBoardSelectedCellRepository _gameBoardSelectedCellRepository;
  final GameBoardRepository _boardRepository;
  final GamePlayerRepository _playerRepository;
  final SocketService _socketService;

  GameCellDetailWidgetViewModel({
    required GameBoardSelectedCellRepository gameBoardSelectedCellRepository,
    required GameBoardRepository boardRepository,
    required GamePlayerRepository playerRepository,
    required SocketService socketService,
  }) : _gameBoardSelectedCellRepository = gameBoardSelectedCellRepository,
       _boardRepository = boardRepository,
       _playerRepository = playerRepository,
       _socketService = socketService;

  late final cellDetail = computed<GameCellDetailUiState>(() {
    final selection = _gameBoardSelectedCellRepository.state.value;
    final boardState = _boardRepository.state.value;
    final board = boardState.board;
    final playerState = _playerRepository.state.value;
    final socketId = _socketService.socketIdOption.match(() => '', (id) => id);
    return selectionToCellDetail(
      selection,
      board,
      socketId,
      playerState,
      boardState,
    );
  });

  bool get hasDetail => cellDetail.value is! GameCellDetailEmpty;
}
