import 'package:get_it/get_it.dart';

import '../../../../core/services/socket_service.dart';
import '../../data/projections/session_connection_projection.dart';
import '../../data/repositories/session_repository.dart';

void registerSessionConnectionProjection(GetIt scope, GetIt rootGetIt) {
  scope.registerLazySingleton<SessionConnectionProjection>(
    () => SessionConnectionProjection(
      socketService: rootGetIt.get<SocketService>(),
      sessionRepository: scope.get<SessionRepository>(),
    ),
  );
}
