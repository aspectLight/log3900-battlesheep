import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../../core/app_transition/app_transition_bus.dart';
import '../../../core/app_events/game_history_events.dart';
import '../../../data/repositories/game_history_repository.dart';
import '../../../domain/state/game_history_state.dart';

class GameHistoryViewModel {
  GameHistoryViewModel({
    required GameHistoryRepository repository,
    required AppTransitionEventBus appTransitionEventBus,
  }) : _repository = repository,
       _appTransitionEventBus = appTransitionEventBus,
       state = computed(() => repository.state.value);

  final GameHistoryRepository _repository;
  final AppTransitionEventBus _appTransitionEventBus;

  final Computed<GameHistoryState> state;

  Future<void> loadHistory() => _repository.loadHistory();

  void requestLeave() {
    _appTransitionEventBus.fire(const GameHistoryExitAppEvent.leaveRequested());
  }
}
