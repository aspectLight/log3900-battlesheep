import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../../core/app_transition/app_transition_bus.dart';
import '../../../core/app_events/logs_history_events.dart';
import '../../../data/repositories/logs_history_repository.dart';
import '../../../domain/state/logs_history_state.dart';

class LogsHistoryViewModel {
  LogsHistoryViewModel({
    required LogsHistoryRepository repository,
    required AppTransitionEventBus appTransitionEventBus,
  }) : _repository = repository,
       _appTransitionEventBus = appTransitionEventBus,
       state = computed(() => repository.state.value);

  final LogsHistoryRepository _repository;
  final AppTransitionEventBus _appTransitionEventBus;

  final Computed<LogsHistoryState> state;

  Future<void> loadHistory() => _repository.loadHistory();

  void requestLeave() {
    _appTransitionEventBus.fire(const LogsHistoryExitAppEvent.leaveRequested());
  }
}
