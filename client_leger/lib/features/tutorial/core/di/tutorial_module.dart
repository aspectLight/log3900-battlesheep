import 'package:get_it/get_it.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../routing/app_navigator.dart';
import '../../../authentication/core/interfaces/auth_repository.dart';
import '../../data/services/http_tutorial_service.dart';
import '../../presentation/screens/tutorial_view_model.dart';
import '../coordinators/tutorial_coordinator.dart';

void registerTutorialRoot(GetIt getIt) {
  getIt.registerLazySingleton<TutorialCoordinator>(
    () => TutorialCoordinator(
      appNavigator: getIt<AppNavigator>(),
      tutorialService: getIt<HttpTutorialService>(),
    ),
  );

  getIt.registerFactory<TutorialViewModel>(
    () => TutorialViewModel(
      tutorialService: getIt<HttpTutorialService>(),
      appTransitionEventBus: getIt<AppTransitionEventBus>(),
    ),
  );

  getIt.registerFactory<HttpTutorialService>(
    () => HttpTutorialService(authRepository: getIt<AuthRepository>()),
  );
}
