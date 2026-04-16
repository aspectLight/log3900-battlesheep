import 'package:get_it/get_it.dart';

import '../../../authentication/core/interfaces/auth_repository.dart';
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

void registerGameRootServices(GetIt getIt) {
  getIt.registerLazySingleton<GameService>(
    () => GameService(getIt<Dio>(), getIt<AuthRepository>()),
  );
}

void registerGameScopeServices(GetIt scope, GetIt rootGetIt) {
  final socketService = rootGetIt<SocketService>();
  scope.registerSingleton<GameActionsSocket>(
    GameActionsSocket(socketService: socketService),
    dispose: (socket) => socket.dispose(),
  );
  scope.registerSingleton<GameBoardSocket>(
    GameBoardSocket(socketService: socketService),
    dispose: (socket) => socket.dispose(),
  );
  scope.registerSingleton<GameEventsSocket>(
    GameEventsSocket(socketService: socketService),
    dispose: (socket) => socket.dispose(),
  );
  scope.registerSingleton<GameCombatSocket>(
    GameCombatSocket(socketService: socketService),
    dispose: (socket) => socket.dispose(),
  );
  scope.registerSingleton<GameItemSocket>(
    GameItemSocket(socketService: socketService),
    dispose: (socket) => socket.dispose(),
  );
  scope.registerSingleton<GamePlayerMovementSocket>(
    GamePlayerMovementSocket(socketService: socketService),
    dispose: (socket) => socket.dispose(),
  );
  scope.registerSingleton<GameDebugSocket>(
    GameDebugSocket(socketService: socketService),
    dispose: (socket) => socket.dispose(),
  );
}
