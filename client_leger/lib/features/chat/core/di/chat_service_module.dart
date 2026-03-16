import 'package:get_it/get_it.dart';

import '../../../../core/services/socket_service.dart';
import '../../data/services/chat_socket.dart';

void registerChatService(GetIt getIt) {
  getIt.registerLazySingleton<ChatSocket>(
    () => ChatSocket(socketService: getIt<SocketService>()),
  );
}
