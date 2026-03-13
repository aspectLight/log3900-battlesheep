import 'package:get_it/get_it.dart';

import '../../data/repositories/select_game_session_repository.dart';
import '../../domain/use_cases/confirm_selection_use_case.dart';

void registerSelectGameSessionUseCases(GetIt getIt) {
  getIt.registerFactory<ConfirmSelectionUseCase>(
    () => ConfirmSelectionUseCase(
      repository: getIt<SelectGameSessionRepository>(),
    ),
  );
}

