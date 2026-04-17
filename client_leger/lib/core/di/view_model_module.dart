import 'package:get_it/get_it.dart';

import '../../features/tutorial/core/coordinators/tutorial_coordinator.dart';
import '../app_transition/app_transition_bus.dart';
import '../presentation/screens/main_menu/main_menu_view_model.dart';

void registerViewModels(GetIt getIt) {
  getIt.registerFactory<MainMenuViewModel>(
    () => MainMenuViewModel(
      appTransitionEventBus: getIt<AppTransitionEventBus>(),
      tutorialCoordinator: getIt<TutorialCoordinator>(),
    ),
  );
}
