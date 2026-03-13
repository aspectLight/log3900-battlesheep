import 'package:get_it/get_it.dart';

import '../../../../../core/app_transition/app_transition_bus.dart';
import '../../core/event_bus/select_game_session_event_bus.dart';
import '../../core/modal/select_game_session_modal_intents.dart';
import '../../data/repositories/select_game_session_repository.dart';
import '../../domain/use_cases/confirm_selection_use_case.dart';
import '../../presentation/screens/select_game_session/select_game_session_view_model.dart';
import '../../presentation/widgets/select_game_session/select_game_session_panel_view_model.dart';
import '../../presentation/widgets/select_game_session_modal/select_game_session_game_preview_modal_content_view_model.dart';

void registerSelectGameSessionViewModels(GetIt getIt) {
  getIt.registerFactory<SelectGameSessionViewModel>(
    () => SelectGameSessionViewModel(
      appTransitionEventBus: getIt<AppTransitionEventBus>(),
    ),
  );

  getIt.registerFactory<SelectGameSessionPanelViewModel>(
    () => SelectGameSessionPanelViewModel(
      confirmSelectionUseCase: getIt<ConfirmSelectionUseCase>(),
      repository: getIt<SelectGameSessionRepository>(),
      eventBus: getIt<SelectGameSessionEventBus>(),
      appTransitionEventBus: getIt<AppTransitionEventBus>(),
    ),
  );

  getIt.registerFactoryParam<
    SelectGameSessionGamePreviewModalContentViewModel,
    SelectGameSessionGamePreviewModalIntent,
    void Function()
  >(
    (intent, onClose) => SelectGameSessionGamePreviewModalContentViewModel(
      intent: intent,
      onClose: onClose,
    ),
  );
}
