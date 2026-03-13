import 'package:get_it/get_it.dart';

import '../../data/projections/chat_events_projection.dart';
import '../../data/repositories/chat_repository.dart';
import '../../data/services/chat_socket.dart';

void registerChatProjection(GetIt scope, GetIt rootGetIt) {
  scope.registerLazySingleton<ChatEventsProjection>(
    () => ChatEventsProjection(
      chatRepository: scope.get<ChatRepository>(),
      chatSocket: rootGetIt.get<ChatSocket>(),
    ),
  );
}
