import 'package:get_it/get_it.dart';

import '../../../authentication/core/interfaces/auth_repository.dart';
import '../../data/services/http_game_history_service.dart';

void registerGameHistoryServices(GetIt getIt) {
  getIt.registerLazySingleton<HttpGameHistoryService>(
    () => HttpGameHistoryService(authRepository: getIt<AuthRepository>()),
  );
}
