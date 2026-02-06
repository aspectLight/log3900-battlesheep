import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../data/services/firebase_auth_service.dart';
import '../../data/services/http_auth_service.dart';
import '../../data/services/socket_service.dart';
import '../../domain/interfaces/repositories/auth_repository.dart';
import '../../domain/interfaces/repositories/chat_repository.dart';
import '../../domain/interfaces/services/auth_service.dart';
import '../../domain/interfaces/services/firebase_auth_service.dart';
import '../../domain/interfaces/services/socket_service.dart';
import '../../presentation/screens/login/login_view_model.dart';
import '../../presentation/screens/main_menu/main_menu_view_model.dart';
import '../../presentation/screens/sign_up/sign_up_view_model.dart';
import '../../presentation/widgets/avatar_picker/avatar_picker_view_model.dart';
import '../../presentation/widgets/chat_line/chat_line_view_model.dart';
import '../../presentation/widgets/chat_panel_content/chat_panel_content_view_model.dart';
import '../../presentation/widgets/loading_overlay/loading_overlay_view_model.dart';
import '../../presentation/widgets/sliding_chat_box/sliding_chat_box_view_model.dart';
import '../../routing/app_router.dart';
import '../../routing/auth_guard.dart';
import '../config/env_config.dart';
import '../session/session_credentials.dart';
import '../session/user_session.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  _registerServices();
  _registerRepositories();
  _registerSession();
  _registerViewModels();
  _registerRouting();
  await getIt.allReady();
}

void _registerServices() {
  getIt.registerSingletonAsync<Dio>(() async {
    final dio = Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));
    final appDocDir = await getApplicationDocumentsDirectory();
    final cookieJar = PersistCookieJar(
      storage: FileStorage('${appDocDir.path}/.cookies/'),
    );
    dio.interceptors.add(CookieManager(cookieJar));
    return dio;
  });

  getIt.registerLazySingleton<SessionCredentials>(SessionCredentials.new);

  getIt.registerLazySingleton<AuthService>(
    () => HttpAuthService(
      credentials: getIt<SessionCredentials>(),
      dio: getIt<Dio>(),
    ),
  );

  getIt.registerLazySingleton<FirebaseAuthService>(FirebaseAuthServiceImpl.new);

  getIt.registerLazySingleton<SocketService>(SocketServiceImpl.new);
}

void _registerRepositories() {
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authService: getIt<AuthService>(),
      firebaseAuthService: getIt<FirebaseAuthService>(),
    ),
  );

  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      socketService: getIt<SocketService>(),
      userSession: getIt<UserSession>(),
    ),
  );
}

void _registerSession() {
  getIt.registerLazySingleton<UserSession>(
    () => UserSession(
      socketService: getIt<SocketService>(),
      authRepository: getIt<AuthRepository>(),
    ),
  );
}

void _registerViewModels() {
  getIt.registerLazySingleton<LoadingOverlayViewModel>(
    LoadingOverlayViewModel.new,
  );

  getIt.registerFactory<MainMenuViewModel>(
    () => MainMenuViewModel(
      userSession: getIt<UserSession>(),
      authRepository: getIt<AuthRepository>(),
    ),
  );

  getIt.registerFactory<LoginViewModel>(
    () => LoginViewModel(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerFactory<SignUpViewModel>(
    () => SignUpViewModel(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerFactory<AvatarPickerViewModel>(AvatarPickerViewModel.new);

  getIt.registerLazySingleton<SlidingChatBoxViewModel>(
    SlidingChatBoxViewModel.new,
  );
  getIt.registerLazySingleton<ChatPanelContentViewModel>(
    () => ChatPanelContentViewModel(
      repository: getIt<ChatRepository>(),
      userSession: getIt<UserSession>(),
    ),
  );
  getIt.registerLazySingleton<ChatLineViewModel>(ChatLineViewModel.new);
}

void _registerRouting() {
  getIt.registerLazySingleton<AuthGuard>(
    () => AuthGuard(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<AppRouter>(
    () => AppRouter(authGuard: getIt<AuthGuard>()),
  );
}
