import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/services/socket_service.dart';
import '../../../../routing/app_navigator.dart';
import '../../../authentication/core/interfaces/auth_repository.dart';
import '../../data/friends_http_service.dart';
import '../../data/friends_socket_listener.dart';
import '../../domain/interfaces/friends_repository.dart';
import '../../presentation/screens/friends_view_model.dart';
import '../coordinators/friends_coordinator.dart';

void registerFriendsRoot(GetIt getIt) {
  getIt.registerLazySingleton<FriendsRepository>(
    () => FriendsHttpService(
      dio: getIt<Dio>(),
      authRepository: getIt<AuthRepository>(),
    ),
  );
  getIt.registerLazySingleton<FriendsCoordinator>(
    () => FriendsCoordinator(appNavigator: getIt<AppNavigator>()),
  );
  getIt.registerLazySingleton<FriendsViewModel>(
    () => FriendsViewModel(
      appTransitionEventBus: getIt<AppTransitionEventBus>(),
      repository: getIt<FriendsRepository>(),
    ),
  );
  getIt.registerLazySingleton<FriendsSocketListener>(
    () => FriendsSocketListener(
      socketService: getIt<SocketService>(),
      viewModel: getIt<FriendsViewModel>(),
    ),
  );
}
