import 'package:get_it/get_it.dart';

import '../../../../features/discussion_canals/domain/interfaces/discussion_canals_repository.dart';
import '../../data/repositories/chat_panel_state_repository.dart';
import '../../data/repositories/chat_repository.dart';
import '../../presentation/widgets/chat_panel_content/chat_panel_content_view_model.dart';
import '../../presentation/widgets/sliding_chat_box/sliding_chat_box_view_model.dart';

void registerChatViewModels(
  GetIt scope,
  GetIt rootGetIt, {
  required String username,
}) {
  scope.registerLazySingleton<SlidingChatBoxViewModel>(
    () => SlidingChatBoxViewModel(
      canalsRepository: rootGetIt<DiscussionCanalsRepository>(),
    ),
  );
  scope.registerFactory<ChatPanelContentViewModel>(
    () => ChatPanelContentViewModel(
      repository: scope.get<ChatRepository>(),
      panelStateRepository: scope.get<ChatPanelStateRepository>(),
      currentUsername: username,
    ),
  );
}
