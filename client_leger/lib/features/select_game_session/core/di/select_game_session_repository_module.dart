import 'package:get_it/get_it.dart';

import '../../data/repositories/select_game_session_currency_repository.dart';
import '../../data/repositories/select_game_session_repository.dart';
import '../../data/services/select_game_session_currency_socket.dart';
import '../../data/services/select_game_session_http_service.dart';

void registerSelectGameSessionRepositories(GetIt getIt) {
  getIt.registerLazySingleton<SelectGameSessionRepository>(
    () => SelectGameSessionRepository(
      httpService: getIt<SelectGameSessionHttpService>(),
    ),
  );
  getIt.registerLazySingleton<SelectGameSessionCurrencyRepository>(
    () => SelectGameSessionCurrencyRepository(
      socket: getIt<SelectGameSessionCurrencySocket>(),
    ),
  );
}
