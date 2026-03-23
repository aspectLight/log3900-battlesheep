import 'package:get_it/get_it.dart';

import '../config/env_config.dart';
import '../services/socket_service.dart';

void registerCoreServices(GetIt getIt) {
  getIt.registerLazySingleton<SocketService>(
    () => SocketService(url: EnvConfig.socketUrl),
  );
}
