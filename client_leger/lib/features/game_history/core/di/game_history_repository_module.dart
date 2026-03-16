import 'package:get_it/get_it.dart';

import '../../data/repositories/game_history_repository.dart';
import '../../data/services/http_game_history_service.dart';

void registerGameHistoryRepositories(GetIt getIt) {
  getIt.registerLazySingleton<GameHistoryRepository>(
    () => GameHistoryRepository(getIt<HttpGameHistoryService>()),
  );
}
