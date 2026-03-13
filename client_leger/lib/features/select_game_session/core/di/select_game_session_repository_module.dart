import 'package:get_it/get_it.dart';

import '../../data/repositories/select_game_session_repository.dart';
import '../../data/services/select_game_session_http_service.dart';

void registerSelectGameSessionRepositories(GetIt getIt) {
  getIt.registerLazySingleton<SelectGameSessionRepository>(
    () => SelectGameSessionRepository(
      httpService: getIt<SelectGameSessionHttpService>(),
    ),
  );
}
