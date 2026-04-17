import 'package:get_it/get_it.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/connected_scope/session_scope_manager.dart';
import '../../../../core/notification/notification_intent_sink.dart';
import '../../../profile/data/services/http_profile_service.dart';
import '../../../shop/data/repositories/shop_repository.dart';
import '../../data/repositories/character_creation_repository.dart';
import '../../domain/models/character_creation_entry_mode.dart';
import '../../domain/use_cases/create_character_use_case.dart';
import '../../domain/use_cases/reserve_character_use_case.dart';
import '../event_bus/character_creation_event_bus.dart';
import '../../presentation/screens/character_creation/character_creation_view_model.dart';

void registerCharacterCreationScopeViewModels(
  GetIt scope,
  GetIt rootGetIt, {
  required String socketId,
  required CharacterCreationEntryMode entryMode,
}) {
  scope.registerFactory<CharacterCreationViewModel>(() {
    final session = rootGetIt.get<SessionScopeManager>().currentSession;
    final username = session!.username;
    return CharacterCreationViewModel(
      createCharacterUseCase: scope.get<CreateCharacterUseCase>(),
      reserveCharacterUseCase: scope.get<ReserveCharacterUseCase>(),
      repository: scope.get<CharacterCreationRepository>(),
      profileService: rootGetIt.get<HttpProfileService>(),
      shopRepository: scope.get<ShopRepository>(),
      notificationIntentSink: rootGetIt.get<NotificationIntentSink>(),
      eventBus: rootGetIt.get<CharacterCreationEventBus>(),
      appTransitionEventBus: rootGetIt.get<AppTransitionEventBus>(),
      socketId: socketId,
      entryMode: entryMode,
      username: username,
    );
  });
}
