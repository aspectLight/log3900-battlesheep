import 'package:get_it/get_it.dart';

import '../../data/side_effects/chat_shake_side_effect.dart';
import '../event_bus/chat_event_bus.dart';
import '../../data/repositories/chat_panel_state_repository.dart';
import '../../data/repositories/chat_repository.dart';

void registerChatSideEffects(GetIt scope, {required String username}) {
  scope.registerSingleton<ChatShakeSideEffect>(
    ChatShakeSideEffect(
      username: username,
      chatEventBus: scope.get<ChatEventBus>(),
      chatRepository: scope.get<ChatRepository>(),
      panelStateRepository: scope.get<ChatPanelStateRepository>(),
    ),
    dispose: (effect) => effect.dispose(),
  );
}
