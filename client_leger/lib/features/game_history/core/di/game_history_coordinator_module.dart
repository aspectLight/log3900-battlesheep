import 'package:get_it/get_it.dart';

import '../../../../routing/app_navigator.dart';
import '../coordinators/game_history_coordinator.dart';

void registerGameHistoryCoordinator(GetIt getIt) {
  getIt.registerLazySingleton<GameHistoryCoordinator>(
    () => GameHistoryCoordinator(appNavigator: getIt<AppNavigator>()),
  );
}
