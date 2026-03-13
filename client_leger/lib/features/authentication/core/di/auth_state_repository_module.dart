import 'package:get_it/get_it.dart';

import '../../data/repositories/session_repository.dart';

void registerSessionRepository(GetIt scope) {
  scope.registerLazySingleton<SessionRepository>(SessionRepository.new);
}
