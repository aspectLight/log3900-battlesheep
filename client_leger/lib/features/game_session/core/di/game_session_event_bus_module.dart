import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';

import '../event_bus/game_session_event_bus.dart';

void registerGameSessionEventBus(GetIt getIt) {
  getIt.registerLazySingleton<GameSessionEventBus>(
    () => GameSessionEventBus(getIt<EventBus>()),
  );
}
