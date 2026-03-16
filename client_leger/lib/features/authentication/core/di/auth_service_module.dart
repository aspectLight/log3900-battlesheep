import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/config/env_config.dart';
import '../../data/services/firebase_auth_service.dart';
import '../../data/services/http_auth_service.dart';

void registerAuthServices(GetIt getIt) {
  getIt.registerSingletonAsync<HttpAuthService>(() async {
    return HttpAuthService(dio: getIt<Dio>());
  });
  getIt.registerLazySingleton<FirebaseAuthService>(
    () => FirebaseAuthService(
      dio: getIt<Dio>(),
      apiKey: EnvConfig.firebaseApiKey,
      baseUrl: EnvConfig.firebaseAuthBaseUrl,
    ),
  );
}
