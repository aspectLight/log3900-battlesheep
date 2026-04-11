import 'package:get_it/get_it.dart';

import '../../../../core/di/scoped_projection_subscriptions.dart';
import '../../core/event_bus/character_creation_event_bus.dart';
import '../../data/projections/character_creation_events_projection.dart';
import '../../data/repositories/character_creation_repository.dart';
import '../../data/services/character_creation_socket.dart';

void registerCharacterCreationProjections(GetIt scope, GetIt rootGetIt) {
  scope.registerLazySingleton<CharacterCreationEventsProjection>(
    () => CharacterCreationEventsProjection(
      socket: scope.get<CharacterCreationSocket>(),
      repository: scope.get<CharacterCreationRepository>(),
      eventBus: rootGetIt.get<CharacterCreationEventBus>(),
    ),
  );
}

void bootstrapCharacterCreationScope(GetIt scope) {
  registerScopedProjectionSubscriptions(
    scope,
    scope.get<CharacterCreationEventsProjection>().subscribe(),
  );
  scope.get<CharacterCreationRepository>().loadReservedCharacters();
}
