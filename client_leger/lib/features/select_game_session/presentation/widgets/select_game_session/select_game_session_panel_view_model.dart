import 'package:fpdart/fpdart.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/app_transition/app_transition_bus.dart';
import '../../../../../core/helpers/functional_programming.dart';
import '../../../core/app_events/select_game_session_events.dart';
import '../../../core/event_bus/select_game_session_event_bus.dart';
import '../../../data/repositories/select_game_session_repository.dart';
import '../../../domain/commands/select_game_session_commands.dart';
import '../../../domain/state/select_game_session_state.dart';
import '../../../domain/use_cases/confirm_selection_use_case.dart';

class SelectGameSessionPanelViewModel {
  SelectGameSessionPanelViewModel({
    required ConfirmSelectionUseCase confirmSelectionUseCase,
    required SelectGameSessionRepository repository,
    required SelectGameSessionEventBus eventBus,
    required AppTransitionEventBus appTransitionEventBus,
  }) : _confirmSelectionUseCase = confirmSelectionUseCase,
       _repository = repository,
       _eventBus = eventBus,
       _appTransitionEventBus = appTransitionEventBus;

  final ConfirmSelectionUseCase _confirmSelectionUseCase;
  final SelectGameSessionRepository _repository;
  final SelectGameSessionEventBus _eventBus;
  final AppTransitionEventBus _appTransitionEventBus;

  final _state = signal<SelectGameSessionState>(
    const SelectGameSessionState.loaded(
      games: [],
      isLoadingGames: true,
    ),
  );

  final _selectedGameId = signal<Option<String>>(const Option.none());

  final friendsOnly = signal<bool>(false);

  Signal<SelectGameSessionState> get state => _state;

  Signal<Option<String>> get selectedGameId => _selectedGameId;

  Future<void> load() async {
    _state.value = _state.value.copyWith(isLoadingGames: true);
    _selectedGameId.value = const Option.none();
    final result = await _repository.loadGames().run();
    _state.value = result.match(
      (_) => const SelectGameSessionState.loaded(games: []),
      (games) => SelectGameSessionState.loaded(games: games),
    );
  }

  void selectGame(String gameId) {
    _selectedGameId.value = Option.of(gameId);
  }

  void toggleFriendsOnly() => friendsOnly.value = !friendsOnly.value;

  Future<void> confirmSelectionSubmit() async {
    final current = _state.value;
    if (_selectedGameId.value.isNone()) return;

    _state.value = current.copyWith(isConfirming: true);

    final result = await _confirmSelectionUseCase
        .execute(
          ConfirmSelectionCommand(
            selectedGameId: _selectedGameId.value.assumePresent(),
          ),
        )
        .run();

    result.match(
      (failure) {
        final failedId = _selectedGameId.value.assumePresent();
        _selectedGameId.value = const Option.none();
        _state.value = current.copyWith(
          isConfirming: false,
          games: current.games.where((g) => g.id != failedId).toList(),
        );
        _eventBus.fire(ConfirmSelectionFailed(failure));
      },
      (model) {
        _state.value = _state.value.copyWith(isConfirming: false);
        _appTransitionEventBus.fire(
          SelectGameSessionExitAppEvent.gameSelected(
            gameId: model.id,
            gameName: model.name,
            gameDescription: model.description,
            gameMode: model.mode,
            boardSize: model.boardSize,
            friendsOnly: friendsOnly.value,
          ),
        );
      },
    );
  }
}
