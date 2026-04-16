import 'package:get_it/get_it.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../data/repositories/game_history_repository.dart';
import '../../presentation/screens/game_history/game_history_view_model.dart';

void registerGameHistoryViewModels(GetIt getIt) {
  getIt.registerFactory<GameHistoryViewModel>(
    () => GameHistoryViewModel(
      repository: getIt<GameHistoryRepository>(),
      appTransitionEventBus: getIt<AppTransitionEventBus>(),
    ),
  );
}
