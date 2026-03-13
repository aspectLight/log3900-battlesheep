import 'package:get_it/get_it.dart';

import '../../data/services/select_game_session_http_service.dart';

void registerSelectGameSessionServices(GetIt getIt) {
  getIt.registerLazySingleton<SelectGameSessionHttpService>(
    SelectGameSessionHttpService.new,
  );
}

