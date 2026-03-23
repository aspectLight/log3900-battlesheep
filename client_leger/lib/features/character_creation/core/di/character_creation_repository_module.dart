import 'package:get_it/get_it.dart';

import '../../data/repositories/character_creation_repository.dart';
import '../../data/services/character_creation_socket.dart';

void registerCharacterCreationRepositories(
  GetIt scope,
  GetIt rootGetIt, {
  required String roomCode,
}) {
  scope.registerLazySingleton<CharacterCreationRepository>(
    () => CharacterCreationRepository(
      socket: scope.get<CharacterCreationSocket>(),
      roomCode: roomCode,
    ),
  );
}
