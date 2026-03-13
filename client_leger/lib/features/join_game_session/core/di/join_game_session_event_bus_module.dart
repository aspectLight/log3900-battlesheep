import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';

import '../event_bus/join_game_session_event_bus.dart';

void registerJoinGameSessionEventBus(GetIt getIt) {
  getIt.registerLazySingleton<JoinGameSessionEventBus>(
    () => JoinGameSessionEventBus(getIt<EventBus>()),
  );
}
