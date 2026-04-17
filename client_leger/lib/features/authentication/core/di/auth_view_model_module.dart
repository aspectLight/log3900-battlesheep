import 'package:get_it/get_it.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/appearance/app_appearance_service.dart';
import '../../../../routing/app_navigator.dart';
import '../../core/interfaces/auth_repository.dart';
import '../../../profile/data/services/http_profile_service.dart';
import '../../presentation/screens/auth_landing/auth_landing_view_model.dart';
import '../../presentation/screens/login/login_view_model.dart';
import '../../presentation/screens/sign_up/sign_up_view_model.dart';
import '../../presentation/widgets/avatar_picker/avatar_picker_view_model.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../../domain/use_cases/sign_up_use_case.dart';

void registerAuthViewModels(GetIt getIt) {
  getIt.registerFactory<AvatarPickerViewModel>(AvatarPickerViewModel.new);
  getIt.registerFactory<AuthLandingViewModel>(
    () => AuthLandingViewModel(appNavigator: getIt<AppNavigator>()),
  );
  getIt.registerFactory<LoginViewModel>(
    () => LoginViewModel(
      loginUseCase: getIt<LoginUseCase>(),
      appTransitionEventBus: getIt<AppTransitionEventBus>(),
    ),
  );
  getIt.registerFactory<SignUpViewModel>(
    () => SignUpViewModel(
      signUpUseCase: getIt<SignUpUseCase>(),
      appTransitionEventBus: getIt<AppTransitionEventBus>(),
      profileService: getIt<HttpProfileService>(),
      authRepository: getIt<AuthRepository>(),
      appearance: getIt<AppAppearanceService>(),
    ),
  );
}
