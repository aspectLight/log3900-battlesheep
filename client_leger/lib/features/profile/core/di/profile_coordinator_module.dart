import 'package:get_it/get_it.dart';

import '../../../../routing/app_navigator.dart';
import '../coordinators/profile_coordinator.dart';

void registerProfileCoordinator(GetIt getIt) {
  getIt.registerLazySingleton<ProfileCoordinator>(
    () => ProfileCoordinator(appNavigator: getIt<AppNavigator>()),
  );
}
