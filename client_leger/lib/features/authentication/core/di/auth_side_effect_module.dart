import 'package:get_it/get_it.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/services/socket_service.dart';
import '../interfaces/auth_repository.dart';
import '../../data/side_effects/socket_connection_side_effect.dart';

void registerAuthSideEffects(GetIt getIt) {
  getIt.registerLazySingleton<SocketConnectionSideEffect>(
    () => SocketConnectionSideEffect(
      authRepository: getIt<AuthRepository>(),
      socketService: getIt<SocketService>(),
      appTransitionEventBus: getIt<AppTransitionEventBus>(),
    ),
  );
}

void bootstrapAuthSideEffects(GetIt getIt) {
  getIt.get<SocketConnectionSideEffect>();
}
