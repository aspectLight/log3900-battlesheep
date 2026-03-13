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
    const SelectGameSessionState.loading(),
  );

  Signal<SelectGameSessionState> get state => _state;

  Future<void> load() async {
    _state.value = const SelectGameSessionState.loading();
    final result = await _repository.loadVisibleGames().run();
    _state.value = result.match(
      (_) => const SelectGameSessionState.loaded(
        games: [],
        selectedGameId: Option.none(),
      ),
      (games) => SelectGameSessionState.loaded(
        games: games,
        selectedGameId: const Option.none(),
      ),
    );
  }

  void selectGame(String gameId) {
    final current = _state.value;
    if (current is! SelectGameSessionStateLoaded) return;
    _state.value = current.copyWith(selectedGameId: Option.of(gameId));
  }

  Future<void> confirmSelectionSubmit() async {
    final current = _state.value;
    if (current is! SelectGameSessionStateLoaded) return;
    if (current.selectedGameId.isNone()) return;

    _state.value = current.copyWith(isConfirming: true);

    final result = await _confirmSelectionUseCase
        .execute(
          ConfirmSelectionCommand(
            selectedGameId: current.selectedGameId.assumePresent(),
          ),
        )
        .run();

    result.match((failure) {
      final failedId = current.selectedGameId.assumePresent();
      _state.value = current.copyWith(
        isConfirming: false,
        selectedGameId: const Option.none(),
        games: current.games.where((g) => g.id != failedId).toList(),
      );
      _eventBus.fire(ConfirmSelectionFailed(failure));
    }, (model) {
      _state.value = current.copyWith(isConfirming: false);
      _appTransitionEventBus.fire(
        SelectGameSessionExitAppEvent.gameSelected(
          gameId: model.id,
          gameName: model.name,
          gameDescription: model.description,
          gameMode: model.mode,
          boardSize: model.boardSize,
        ),
      );
    });
  }
}
