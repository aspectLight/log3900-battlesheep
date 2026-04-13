import 'package:get_it/get_it.dart';

import '../../../../core/services/socket_service.dart';
import '../../data/services/select_game_session_currency_socket.dart';
import '../../data/services/select_game_session_http_service.dart';

void registerSelectGameSessionServices(GetIt getIt) {
  getIt.registerLazySingleton<SelectGameSessionHttpService>(
    SelectGameSessionHttpService.new,
  );
  getIt.registerLazySingleton<SelectGameSessionCurrencySocket>(
    () => SelectGameSessionCurrencySocket(
      socketService: getIt<SocketService>(),
    ),
  );
}

