import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';

import '../../../authentication/core/interfaces/auth_repository.dart';
import '../event_bus/chat_event_bus.dart';
import '../../data/reducers/chat_state_reducer.dart';
import '../../data/repositories/chat_panel_state_repository.dart';
import '../../data/repositories/chat_repository.dart';
import '../../data/services/chat_socket.dart';

void registerChatRepositories(
  GetIt scope,
  GetIt rootGetIt, {
  required String username,
}) {
  scope.registerLazySingleton<EventBus>(EventBus.new);
  scope.registerLazySingleton<ChatEventBus>(
    () => ChatEventBus(scope.get<EventBus>()),
  );
  scope.registerLazySingleton<ChatPanelStateRepository>(
    ChatPanelStateRepository.new,
  );
  scope.registerLazySingleton<ChatRepository>(
    () => ChatRepository(
      chatSocket: scope.get<ChatSocket>(),
      reducer: rootGetIt.get<ChatStateReducer>(),
      authRepository: rootGetIt<AuthRepository>(),
      initialGeneralChatUsername: username,
    ),
  );
}
