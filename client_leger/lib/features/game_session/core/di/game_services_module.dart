import 'package:get_it/get_it.dart';

import '../../data/services/game_actions_socket.dart';
import '../../data/services/game_board_socket.dart';
import '../../data/services/game_combat_socket.dart';
import '../../data/services/game_debug_socket.dart';
import '../../data/services/game_events_socket.dart';
import '../../data/services/game_item_socket.dart';
import '../../data/services/game_player_movement_socket.dart';
import '../../data/services/game_service.dart';
import '../../../../core/services/socket_service.dart';
import 'package:dio/dio.dart';

void registerGameServices(GetIt getIt) {
  getIt.registerLazySingleton<GameService>(() => GameService(getIt<Dio>()));
  getIt.registerLazySingleton<GameActionsSocket>(
    () => GameActionsSocket(socketService: getIt<SocketService>()),
  );
  getIt.registerLazySingleton<GameBoardSocket>(
    () => GameBoardSocket(socketService: getIt<SocketService>()),
  );
  getIt.registerLazySingleton<GameEventsSocket>(
    () => GameEventsSocket(socketService: getIt<SocketService>()),
  );
  getIt.registerLazySingleton<GameCombatSocket>(
    () => GameCombatSocket(socketService: getIt<SocketService>()),
  );
  getIt.registerLazySingleton<GameItemSocket>(
    () => GameItemSocket(socketService: getIt<SocketService>()),
  );
  getIt.registerLazySingleton<GamePlayerMovementSocket>(
    () => GamePlayerMovementSocket(socketService: getIt<SocketService>()),
  );
  getIt.registerLazySingleton<GameDebugSocket>(
    () => GameDebugSocket(socketService: getIt<SocketService>()),
  );
}
