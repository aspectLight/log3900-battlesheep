import 'package:get_it/get_it.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/appearance/app_appearance_service.dart';
import '../../data/repositories/profile_repository.dart';
import '../../presentation/screens/profile/profile_view_model.dart';

void registerProfileViewModels(GetIt getIt) {
  getIt.registerFactory<ProfileViewModel>(
    () => ProfileViewModel(
      repository: getIt<ProfileRepository>(),
      appTransitionEventBus: getIt<AppTransitionEventBus>(),
      appearance: getIt<AppAppearanceService>(),
    ),
  );
}

