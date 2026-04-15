import 'package:get_it/get_it.dart';

import '../../../../../core/app_transition/app_transition_bus.dart';
import '../../../../../core/connected_scope/session_scope_manager.dart';
import '../../../../../core/notification/notification_intent.dart';
import '../../../shop/data/repositories/shop_repository.dart';
import '../../domain/use_cases/join_by_code_use_case.dart';
import '../../domain/use_cases/get_available_rooms_use_case.dart';
import '../event_bus/join_game_session_event_bus.dart';
import '../../presentation/screens/join_game_session/join_game_session_view_model.dart';
import '../../presentation/widgets/available_rooms/available_rooms_panel_view_model.dart';
import '../../presentation/widgets/join_by_code/join_by_code_panel_view_model.dart';
import '../../presentation/widgets/join_game_session_failure_notification/join_game_session_failure_notification_view_model.dart';

void registerJoinGameSessionViewModels(GetIt getIt) {
  getIt.registerFactoryParam<
    JoinGameSessionFailureNotificationViewModel,
    JoinGameSessionFailureNotificationIntent,
    void Function()
  >(
    (intent, onDismiss) => JoinGameSessionFailureNotificationViewModel(
      intent: intent,
      onDismiss: onDismiss,
    ),
  );
  getIt.registerFactory<JoinGameSessionViewModel>(
    () => JoinGameSessionViewModel(
      appTransitionEventBus: getIt<AppTransitionEventBus>(),
    ),
  );
  getIt.registerFactory<JoinByCodePanelViewModel>(() {
    final socketId = getIt<SessionScopeManager>().currentSession!.socketId;
    return JoinByCodePanelViewModel(
      joinByCodeUseCase: getIt<JoinByCodeUseCase>(),
      socketId: socketId,
      appTransitionEventBus: getIt<AppTransitionEventBus>(),
      joinGameSessionEventBus: getIt<JoinGameSessionEventBus>(),
    );
  });
  getIt.registerFactory<AvailableRoomsPanelViewModel>(() {
    final socketId = getIt<SessionScopeManager>().currentSession!.socketId;
    return AvailableRoomsPanelViewModel(
      joinByCodeUseCase: getIt<JoinByCodeUseCase>(),
      getAvailableRoomsUseCase: getIt<GetAvailableRoomsUseCase>(),
      socketId: socketId,
      appTransitionEventBus: getIt<AppTransitionEventBus>(),
      joinGameSessionEventBus: getIt<JoinGameSessionEventBus>(),
      shopRepository: getIt<ShopRepository>(),
    );
  });
}
