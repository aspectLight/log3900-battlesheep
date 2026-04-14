import 'package:get_it/get_it.dart';

import '../interfaces/auth_repository.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../../domain/use_cases/sign_up_use_case.dart';

void registerAuthUseCases(GetIt getIt) {
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(authRepository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<SignUpUseCase>(
    () => SignUpUseCase(authRepository: getIt<AuthRepository>()),
  );
}
