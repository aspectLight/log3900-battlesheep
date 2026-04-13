import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../../authentication/core/interfaces/auth_repository.dart';
import '../../data/services/select_game_session_http_service.dart';

void registerSelectGameSessionServices(GetIt getIt) {
  getIt.registerLazySingleton<SelectGameSessionHttpService>(
    () => SelectGameSessionHttpService(
      authRepository: getIt<AuthRepository>(),
      dio: getIt<Dio>(),
    ),
  );
}
