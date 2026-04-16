import 'package:get_it/get_it.dart';

import 'logs_history_coordinator_module.dart';
import 'logs_history_repository_module.dart';
import 'logs_history_service_module.dart';
import 'logs_history_view_model_module.dart';

void registerLogsHistoryRoot(GetIt getIt) {
  registerLogsHistoryServices(getIt);
  registerLogsHistoryRepositories(getIt);
  registerLogsHistoryViewModels(getIt);
  registerLogsHistoryCoordinator(getIt);
}
