import 'package:fpdart/fpdart.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/app_transition/app_transition_bus.dart';
import '../../../../../core/helpers/functional_programming.dart';
import '../../../core/app_events/select_game_session_events.dart';
import '../../../core/event_bus/select_game_session_event_bus.dart';
import '../../../core/exceptions/select_game_session_failure.dart';
import '../../../data/repositories/select_game_session_currency_repository.dart';
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
    required SelectGameSessionCurrencyRepository currencyRepository,
  }) : _confirmSelectionUseCase = confirmSelectionUseCase,
       _repository = repository,
       _eventBus = eventBus,
       _appTransitionEventBus = appTransitionEventBus,
       _currencyRepository = currencyRepository;

  final ConfirmSelectionUseCase _confirmSelectionUseCase;
  final SelectGameSessionRepository _repository;
  final SelectGameSessionEventBus _eventBus;
  final AppTransitionEventBus _appTransitionEventBus;
  final SelectGameSessionCurrencyRepository _currencyRepository;

  final _state = signal<SelectGameSessionState>(
    const SelectGameSessionState.loaded(
      games: [],
      isLoadingGames: true,
    ),
  );

  final entryFee = signal<int>(0);

  late final coinBalance = computed(() => _currencyRepository.balance.value);

  final _selectedGameId = signal<Option<String>>(const Option.none());

  final friendsOnly = signal<bool>(false);

  Signal<SelectGameSessionState> get state => _state;

  Signal<Option<String>> get selectedGameId => _selectedGameId;

  Future<void> load() async {
    _currencyRepository.refreshBalance();
    _state.value = _state.value.copyWith(isLoadingGames: true);
    _selectedGameId.value = const Option.none();
    final result = await _repository.loadGames().run();
    _state.value = result.match(
      (_) => const SelectGameSessionState.loaded(games: []),
      (games) => SelectGameSessionState.loaded(games: games),
    );
  }

  void setEntryFee(int value) {
    entryFee.value = value < 0 ? 0 : value;
  }

  void selectGame(String gameId) {
    _selectedGameId.value = Option.of(gameId);
  }

  void toggleFriendsOnly() => friendsOnly.value = !friendsOnly.value;

  Future<void> confirmSelectionSubmit() async {
    final current = _state.value;
    if (_selectedGameId.value.isNone()) return;

    final fee = entryFee.value;
    final balance = coinBalance.value;
    if (fee > balance) {
      _eventBus.fire(
        const ConfirmSelectionFailed(
          InsufficientFundsSelectGameSessionFailure(),
        ),
      );
      return;
    }

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
            entryFee: fee,
            friendsOnly: friendsOnly.value,
          ),
        );
      },
    );
  }
}
