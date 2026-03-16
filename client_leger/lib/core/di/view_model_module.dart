import 'package:get_it/get_it.dart';

import '../app_transition/app_transition_bus.dart';
import '../../features/authentication/core/interfaces/auth_repository.dart';
import '../presentation/screens/main_menu/main_menu_view_model.dart';
import '../presentation/widgets/loading_overlay/loading_overlay_view_model.dart';

void registerViewModels(GetIt getIt) {
  getIt.registerLazySingleton<LoadingOverlayViewModel>(
    LoadingOverlayViewModel.new,
  );
  getIt.registerFactory<MainMenuViewModel>(
    () => MainMenuViewModel(
      authRepository: getIt<AuthRepository>(),
      appTransitionEventBus: getIt<AppTransitionEventBus>(),
    ),
  );
}
