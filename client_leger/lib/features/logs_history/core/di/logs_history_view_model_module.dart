import 'package:get_it/get_it.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../data/repositories/logs_history_repository.dart';
import '../../presentation/screens/logs_history/logs_history_view_model.dart';

void registerLogsHistoryViewModels(GetIt getIt) {
  getIt.registerFactory<LogsHistoryViewModel>(
    () => LogsHistoryViewModel(
      repository: getIt<LogsHistoryRepository>(),
      appTransitionEventBus: getIt<AppTransitionEventBus>(),
    ),
  );
}
