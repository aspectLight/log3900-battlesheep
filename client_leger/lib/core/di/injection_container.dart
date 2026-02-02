import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../data/services/auth_local_service.dart';
import '../../data/services/chat_service_impl.dart';
import '../../data/services/firebase_auth_service.dart';
import '../../data/services/http_auth_service.dart';
import '../../data/services/socket_chat_service.dart';
import '../../data/services/socket_connection_service.dart';
import '../../domain/interfaces/repositories/auth_repository.dart';
import '../../domain/interfaces/repositories/chat_repository.dart';
import '../../domain/interfaces/services/auth_local_service.dart';
import '../../domain/interfaces/services/auth_service.dart';
import '../../domain/interfaces/services/chat_service.dart';
import '../../domain/interfaces/services/firebase_auth_service.dart';
import '../../domain/interfaces/services/socket_chat_service.dart';
import '../../domain/interfaces/services/socket_connection_service.dart';
import '../../domain/managers/chat_connection_manager.dart';
import '../../domain/managers/socket_connection_manager.dart';
import '../../presentation/view_models/auth_view_model.dart';
import '../../presentation/view_models/chat_view_model.dart';
import '../../presentation/view_models/login_view_model.dart';
import '../../presentation/view_models/sign_up_view_model.dart';
import '../../presentation/view_models/socket_connection_view_model.dart';
import '../../routing/app_router.dart';
import '../../routing/auth_guard.dart';
import '../config/env_config.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  _registerServices();
  _registerRepositories();
  _registerViewModels();
  _registerRouting();
  _registerManagers();
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

  getIt.registerLazySingleton<AuthService>(
    () => HttpAuthService(
      dio: getIt<Dio>(),
      localService: getIt<AuthLocalService>(),
    ),
  );

  getIt.registerLazySingleton<FirebaseAuthService>(FirebaseAuthServiceImpl.new);

  getIt.registerLazySingleton<AuthLocalService>(AuthLocalServiceImpl.new);

  final socketChatServiceImpl = SocketChatServiceImpl();

  getIt.registerLazySingleton<SocketChatServiceImpl>(
    () => socketChatServiceImpl,
  );

  getIt.registerLazySingleton<SocketConnectionService>(
    () => SocketConnectionServiceImpl(
      serverUrl: EnvConfig.socketUrl,
      chatService: getIt<SocketChatServiceImpl>(),
    ),
  );

  getIt.registerLazySingleton<SocketChatService>(() => socketChatServiceImpl);

  getIt.registerLazySingleton<ChatService>(
    () => ChatServiceImpl(chatService: socketChatServiceImpl),
  );
}

void _registerRepositories() {
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authService: getIt<AuthService>(),
      localService: getIt<AuthLocalService>(),
      firebaseAuthService: getIt<FirebaseAuthService>(),
    ),
  );

  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      chatService: getIt<SocketChatService>(),
      connectionService: getIt<SocketConnectionService>(),
    ),
  );
}

void _registerViewModels() {
  getIt.registerFactory<AuthViewModel>(
    () => AuthViewModel(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerFactory<LoginViewModel>(
    () => LoginViewModel(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerFactory<SignUpViewModel>(
    () => SignUpViewModel(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<SocketConnectionViewModel>(
    () => SocketConnectionViewModel(
      connectionService: getIt<SocketConnectionService>(),
      authViewModel: getIt<AuthViewModel>(),
    ),
  );

  getIt.registerFactory<ChatViewModel>(
    () => ChatViewModel(getIt<ChatRepository>()),
  );
}

void _registerManagers() {
  getIt.registerLazySingleton<SocketConnectionManager>(
    () => SocketConnectionManager(
      connectionService: getIt<SocketConnectionService>(),
      authViewModel: getIt<AuthViewModel>(),
    ),
  );

  getIt.registerLazySingleton<ChatConnectionManager>(
    () => ChatConnectionManager(
      chatService: getIt<ChatService>(),
      authViewModel: getIt<AuthViewModel>(),
    ),
  );
}

void _registerRouting() {
  getIt.registerLazySingleton<AuthGuard>(
    () => AuthGuard(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<AppRouter>(
    () => AppRouter(authGuard: getIt<AuthGuard>()),
  );
}
