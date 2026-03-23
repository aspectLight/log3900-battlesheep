import 'package:get_it/get_it.dart';

import 'game_history_coordinator_module.dart';
import 'game_history_repository_module.dart';
import 'game_history_service_module.dart';
import 'game_history_view_model_module.dart';

void registerGameHistoryRoot(GetIt getIt) {
  registerGameHistoryServices(getIt);
  registerGameHistoryRepositories(getIt);
  registerGameHistoryViewModels(getIt);
  registerGameHistoryCoordinator(getIt);
}
