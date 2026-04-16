import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';

import '../event_bus/select_game_session_event_bus.dart';

void registerSelectGameSessionEventBus(GetIt getIt) {
  getIt.registerLazySingleton<SelectGameSessionEventBus>(
    () => SelectGameSessionEventBus(getIt<EventBus>()),
  );
}
