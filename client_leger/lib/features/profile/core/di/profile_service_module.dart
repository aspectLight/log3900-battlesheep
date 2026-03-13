import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../data/services/http_profile_service.dart';
import '../../../authentication/core/interfaces/auth_repository.dart';

void registerProfileServices(GetIt getIt) {
  getIt.registerLazySingleton<HttpProfileService>(
    () => HttpProfileService(
      authRepository: getIt<AuthRepository>(),
      dio: getIt<Dio>(),
    ),
  );
}

