import 'package:get_it/get_it.dart';

import 'join_game_session_coordinator_module.dart';
import 'join_game_session_event_bus_module.dart';
import 'join_game_session_repository_module.dart';
import 'join_game_session_service_module.dart';
import 'join_game_session_side_effect_module.dart';
import 'join_game_session_use_case_module.dart';
import 'join_game_session_view_model_module.dart';

void registerJoinGameSessionRoot(GetIt getIt) {
  registerJoinGameSessionServices(getIt);
  registerJoinGameSessionRepositories(getIt);
  registerJoinGameSessionUseCases(getIt);
  registerJoinGameSessionEventBus(getIt);
  registerJoinGameSessionSideEffects(getIt);
  registerJoinGameSessionViewModels(getIt);
  registerJoinGameSessionCoordinator(getIt);
}
