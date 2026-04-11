import 'package:get_it/get_it.dart';

import '../../../../../core/services/socket_service.dart';
import '../../data/services/join_game_session_socket.dart';

void registerJoinGameSessionServices(GetIt getIt) {
  getIt.registerFactory<JoinGameSessionSocket>(
    () => JoinGameSessionSocket(socketService: getIt<SocketService>()),
  );
}
