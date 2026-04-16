import 'package:get_it/get_it.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/connected_scope/session_scope_manager.dart';
import '../../../../core/di/scoped_projection_subscriptions.dart';
import '../../../../routing/app_navigator.dart';
import '../../data/projections/session_connection_projection.dart';
import '../interfaces/auth_repository.dart';
import '../coordinators/authentication_coordinator.dart';
import '../../../shop/core/di/shop_module.dart';
import 'auth_projection_module.dart';
import 'auth_repository_module.dart';
import 'auth_service_module.dart';
import 'auth_side_effect_module.dart';
import 'auth_state_repository_module.dart';
import 'auth_view_model_module.dart';

void registerAuthRoot(GetIt getIt) {
  registerAuthServices(getIt);
  registerAuthRepository(getIt);
  registerAuthCoordinator(getIt);
  registerAuthViewModels(getIt);
  registerAuthSideEffects(getIt);
}

void registerAuthCoordinator(GetIt getIt) {
  getIt.registerLazySingleton<AuthenticationCoordinator>(
    () => AuthenticationCoordinator(
      getIt: getIt,
      sessionScopeManager: getIt<SessionScopeManager>(),
      appNavigator: getIt<AppNavigator>(),
      authRepository: getIt<AuthRepository>(),
      appTransitionEventBus: getIt<AppTransitionEventBus>(),
    ),
  );
}

void registerConnectedScope(GetIt scope, GetIt rootGetIt) {
  registerSessionRepository(scope);
  registerSessionConnectionProjection(scope, rootGetIt);
  registerShopConnectedScope(scope, rootGetIt);
}

void bootstrapConnectedScope(GetIt scope) {
  registerScopedProjectionSubscriptions(
    scope,
    scope.get<SessionConnectionProjection>().subscribe(),
  );
  bootstrapShopConnectedScope(scope);
}
