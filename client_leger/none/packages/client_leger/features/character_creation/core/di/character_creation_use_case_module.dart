import 'package:get_it/get_it.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../data/repositories/character_creation_repository.dart';
import '../../domain/models/character_creation_entry_mode.dart';
import '../../domain/use_cases/create_character_use_case.dart';
import '../../domain/use_cases/reserve_character_use_case.dart';

void registerCharacterCreationUseCases(
  GetIt scope,
  GetIt rootGetIt, {
  required String roomCode,
  required String socketId,
  required CharacterCreationEntryMode entryMode,
}) {
  scope.registerFactory<CreateCharacterUseCase>(
    () => CreateCharacterUseCase(
      repository: scope.get<CharacterCreationRepository>(),
      appTransitionEventBus: rootGetIt.get<AppTransitionEventBus>(),
      roomCode: roomCode,
      entryMode: entryMode,
      socketId: socketId,
    ),
  );
  scope.registerFactory<ReserveCharacterUseCase>(
    () => ReserveCharacterUseCase(
      repository: scope.get<CharacterCreationRepository>(),
      roomCode: roomCode,
      socketId: socketId,
    ),
  );
}
