import 'package:get_it/get_it.dart';

import 'profile_coordinator_module.dart';
import 'profile_modal_module.dart';
import 'profile_repository_module.dart';
import 'profile_service_module.dart';
import 'profile_view_model_module.dart';

void registerProfileRoot(GetIt getIt) {
  registerProfileServices(getIt);
  registerProfileRepositories(getIt);
  registerProfileViewModels(getIt);
  registerProfileModals(getIt);
  registerProfileCoordinator(getIt);
}
