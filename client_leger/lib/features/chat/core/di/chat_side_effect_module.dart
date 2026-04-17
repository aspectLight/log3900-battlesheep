import 'package:get_it/get_it.dart';

import '../../../../core/chat/chat_outgoing_avatars.dart';
import '../../data/side_effects/chat_shake_side_effect.dart';
import '../../data/repositories/discussion_canals_repository.dart';
import '../event_bus/chat_event_bus.dart';
import '../../data/repositories/chat_panel_state_repository.dart';
import '../../data/repositories/chat_repository.dart';

void registerChatSideEffects(
  GetIt scope,
  GetIt rootGetIt, {
  required String username,
}) {
  scope.registerSingleton<ChatShakeSideEffect>(
    ChatShakeSideEffect(
      username: username,
      chatEventBus: scope.get<ChatEventBus>(),
      chatRepository: scope.get<ChatRepository>(),
      panelStateRepository: scope.get<ChatPanelStateRepository>(),
      outgoingAvatars: rootGetIt<ChatOutgoingAvatars>(),
      canalsRepository: rootGetIt<DiscussionCanalsRepository>(),
    ),
    dispose: (effect) => effect.dispose(),
  );
}
