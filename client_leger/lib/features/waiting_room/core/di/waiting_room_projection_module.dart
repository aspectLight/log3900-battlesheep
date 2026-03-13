import 'package:get_it/get_it.dart';

import '../../../../core/di/scoped_projection_subscriptions.dart';
import '../../data/projections/waiting_room_reservations_projection.dart';
import '../../data/projections/waiting_room_room_projection.dart';
import '../../data/repositories/waiting_room_reservations_repository.dart';
import '../../data/repositories/waiting_room_room_repository.dart';
import '../../data/services/waiting_room_socket.dart';
import '../event_bus/waiting_room_event_bus.dart';

void registerWaitingRoomProjections(GetIt scope, GetIt rootGetIt) {
  final socket = rootGetIt<WaitingRoomSocket>();
  final eventBus = rootGetIt<WaitingRoomEventBus>();
  scope.registerLazySingleton<WaitingRoomRoomProjection>(
    () => WaitingRoomRoomProjection(
      socket: socket,
      repository: scope.get<WaitingRoomRoomRepository>(),
      reservationsRepository: scope.get<WaitingRoomReservationsRepository>(),
      eventBus: eventBus,
    ),
  );
  scope.registerLazySingleton<WaitingRoomReservationsProjection>(
    () => WaitingRoomReservationsProjection(
      socket: socket,
      repository: scope.get<WaitingRoomReservationsRepository>(),
    ),
  );
}

void bootstrapWaitingRoomScope(GetIt scope) {
  registerScopedProjectionSubscriptions(scope, [
    ...scope.get<WaitingRoomRoomProjection>().subscribe(),
    ...scope.get<WaitingRoomReservationsProjection>().subscribe(),
  ]);
}
