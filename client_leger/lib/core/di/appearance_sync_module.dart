import 'package:get_it/get_it.dart';

import '../appearance/appearance_sync_side_effect.dart';
import '../appearance/app_appearance_service.dart';
import '../../features/authentication/core/interfaces/auth_repository.dart';
import '../../features/profile/data/services/http_profile_service.dart';

void registerAppearanceSync(GetIt getIt) {
  getIt.registerLazySingleton<AppearanceSyncSideEffect>(
    () => AppearanceSyncSideEffect(
      authRepository: getIt<AuthRepository>(),
      httpProfileService: getIt<HttpProfileService>(),
      appearance: getIt<AppAppearanceService>(),
    ),
  );
}

void bootstrapAppearanceSync(GetIt getIt) {
  getIt.get<AppearanceSyncSideEffect>();
}
