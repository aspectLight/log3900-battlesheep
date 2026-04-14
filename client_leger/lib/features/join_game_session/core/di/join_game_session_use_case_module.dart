import 'package:get_it/get_it.dart';

import '../../data/repositories/join_game_session_repository.dart';
import '../../domain/use_cases/get_available_rooms_use_case.dart';
import '../../domain/use_cases/join_by_code_use_case.dart';

void registerJoinGameSessionUseCases(GetIt getIt) {
  getIt.registerFactory<JoinByCodeUseCase>(
    () => JoinByCodeUseCase(repository: getIt<JoinGameSessionRepository>()),
  );
  getIt.registerFactory<GetAvailableRoomsUseCase>(
    () => GetAvailableRoomsUseCase(
      repository: getIt<JoinGameSessionRepository>(),
    ),
  );
}
