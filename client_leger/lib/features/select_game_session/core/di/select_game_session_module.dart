import 'package:get_it/get_it.dart';

import 'select_game_session_coordinator_module.dart';
import 'select_game_session_event_bus_module.dart';
import 'select_game_session_modal_module.dart';
import 'select_game_session_repository_module.dart';
import 'select_game_session_service_module.dart';
import 'select_game_session_side_effect_module.dart';
import 'select_game_session_use_case_module.dart';
import 'select_game_session_view_model_module.dart';

void registerSelectGameSessionRoot(GetIt getIt) {
  registerSelectGameSessionServices(getIt);
  registerSelectGameSessionRepositories(getIt);
  registerSelectGameSessionUseCases(getIt);
  registerSelectGameSessionEventBus(getIt);
  registerSelectGameSessionSideEffects(getIt);
  registerSelectGameSessionCoordinator(getIt);
  registerSelectGameSessionViewModels(getIt);
  registerSelectGameSessionModals(getIt);
}
