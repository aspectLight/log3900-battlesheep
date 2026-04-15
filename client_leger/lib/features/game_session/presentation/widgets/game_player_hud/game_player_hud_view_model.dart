import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/helpers/functional_programming.dart';
import '../../../data/repositories/game_player_repository.dart';
import '../../mappers/game_player_hud_ui_mapper.dart';
import '../../ui_models/widget_states/game_player_hud_ui_state.dart';

class GamePlayerHudWidgetViewModel {
  final GamePlayerRepository _playerRepository;
  final String _socketId;

  late final hudModel = computed<GamePlayerHudUiState?>(() {
    final playerState = _playerRepository.state.value;
    return toGamePlayerHudUiState(
      playerState,
      _socketId,
    ).when(none: () => null, some: (x) => x);
  });

  GamePlayerHudWidgetViewModel({
    required GamePlayerRepository playerRepository,
    required String socketId,
  }) : _playerRepository = playerRepository,
       _socketId = socketId;

  void dispose() {}
}
