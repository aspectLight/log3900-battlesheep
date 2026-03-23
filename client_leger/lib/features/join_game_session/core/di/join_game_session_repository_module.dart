import 'package:get_it/get_it.dart';

import '../../data/repositories/join_game_session_repository.dart';
import '../../data/services/join_game_session_socket.dart';

void registerJoinGameSessionRepositories(GetIt getIt) {
  getIt.registerLazySingleton<JoinGameSessionRepository>(
    () => JoinGameSessionRepository(socket: getIt<JoinGameSessionSocket>()),
  );
}
