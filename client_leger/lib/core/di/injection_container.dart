import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';

import '../../features/authentication/core/di/auth_module.dart';
import '../../features/authentication/core/di/auth_repository_module.dart';
import '../../features/authentication/core/di/auth_service_module.dart';
import '../../features/authentication/core/di/auth_side_effect_module.dart';
import '../../features/authentication/core/di/auth_use_case_module.dart';
import '../../features/authentication/core/di/auth_view_model_module.dart';
import '../../features/authentication/core/interfaces/auth_repository.dart';
import '../../features/character_creation/core/di/character_creation_module.dart';
import '../../features/chat/core/di/chat_module.dart';
import '../../features/friends/core/di/friends_module.dart';
import '../../features/game_history/core/di/game_history_module.dart';
import '../../features/game_session/core/di/game_session_module.dart';
import '../../features/join_game_session/core/di/join_game_session_module.dart';
import '../../features/join_game_session/core/di/join_game_session_side_effect_module.dart';
import '../../features/logs_history/core/di/logs_history_module.dart';
import '../../features/profile/core/di/profile_module.dart';
import '../../features/shop/core/di/shop_module.dart';
import '../../features/select_game_session/core/di/select_game_session_module.dart';
import '../../features/select_game_session/core/di/select_game_session_side_effect_module.dart';
import '../../features/statistics/core/di/statistics_module.dart';
import '../../features/tutorial/core/di/tutorial_module.dart';
import '../../features/waiting_room/core/di/waiting_room_module.dart';
import '../../routing/app_navigation_handler.dart';
import '../../routing/app_navigator.dart';
import '../../routing/app_router.dart';
import '../../routing/auth_guard.dart';
import '../../routing/navigation_command.dart';
import '../../routing/route_to_navigation_state_mapper.dart';
import '../app_transition/app_event_handler.dart';
import '../app_transition/app_initialization.dart';
import '../app_transition/app_transition_bus.dart';
import '../config/env_config.dart';
import '../connected_scope/session_scope_manager.dart';
import '../presentation/shell/shell_chrome_back_handler.dart';
import '../modal/modal_module.dart';
import '../notification/notification_module.dart';
import '../presentation/widgets/loading_overlay/loading_overlay_view_model.dart';
import 'app_event_handler_module.dart';
import 'appearance_sync_module.dart';
import 'service_module.dart';
import 'view_model_module.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  registerCoreServices(getIt);
  getIt.registerLazySingleton<Dio>(
    () => Dio(BaseOptions(baseUrl: EnvConfig.baseUrl)),
  );
  getIt.registerLazySingleton<EventBus>(EventBus.new);
  getIt.registerLazySingleton<AppTransitionEventBus>(
    () => AppTransitionEventBus(getIt<EventBus>()),
  );
  getIt.registerLazySingleton<AppInitialization>(AppInitialization.new);
  getIt.registerLazySingleton<SessionScopeManager>(
    () => SessionScopeManager(getIt),
  );
  registerAuthServices(getIt);
  registerAuthRepository(getIt);
  registerAuthUseCases(getIt);
  getIt.registerLazySingleton<AuthGuard>(
    () => AuthGuard(authRepository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<RouteToNavigationStateMapper>(
    RouteToNavigationStateMapper.new,
  );
  getIt.registerLazySingleton<AppRouter>(
    () => AppRouter(authGuard: getIt<AuthGuard>()),
  );
  getIt.registerLazySingleton<LoadingOverlayViewModel>(
    LoadingOverlayViewModel.new,
  );
  getIt.registerLazySingleton<AppNavigator>(
    () => AppNavigationHandler(
      appRouter: getIt<AppRouter>(),
      mapper: getIt<RouteToNavigationStateMapper>(),
      loadingOverlayViewModel: getIt<LoadingOverlayViewModel>(),
    ),
  );
  getIt.registerLazySingleton<ShellChromeBackHandler>(
    ShellChromeBackHandler.new,
  );
  registerAuthCoordinator(getIt);
  registerAuthViewModels(getIt);
  registerAuthSideEffects(getIt);
  registerChatRoot(getIt);
  registerNotificationModule(getIt);
  registerModalModule(getIt);
  registerGameSessionRoot(getIt);
  registerStatisticsRoot(getIt);
  registerSelectGameSessionRoot(getIt);
  registerJoinGameSessionRoot(getIt);
  registerLogsHistoryRoot(getIt);
  registerGameHistoryRoot(getIt);
  registerProfileRoot(getIt);
  registerShopRoot(getIt);
  registerAppearanceSync(getIt);
  registerFriendsRoot(getIt);
  registerTutorialRoot(getIt);
  registerCharacterCreationRoot(getIt);
  registerWaitingRoomRoot(getIt);
  registerAppEventHandler(getIt);
  registerViewModels(getIt);
  await getIt.allReady();
  getIt.get<AppEventHandler>();
  bootstrapAuthSideEffects(getIt);
  bootstrapAppearanceSync(getIt);
  bootstrapSelectGameSessionSideEffects(getIt);
  bootstrapJoinGameSessionSideEffects(getIt);
  getIt<AppInitialization>().setReady();
  getIt<AppNavigator>().request(ForceUnauthenticated());
}
