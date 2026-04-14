import 'package:get_it/get_it.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../data/repositories/waiting_room_reservations_repository.dart';
import '../../data/repositories/waiting_room_room_repository.dart';
import '../../domain/use_cases/add_virtual_player_use_case.dart';
import '../../domain/use_cases/kick_player_use_case.dart';
import '../../domain/use_cases/leave_waiting_room_use_case.dart';
import '../../domain/use_cases/start_waiting_room_game_use_case.dart';
import '../../domain/use_cases/toggle_drop_in_drop_out_use_case.dart';
import '../../domain/use_cases/toggle_lock_waiting_room_use_case.dart';

void registerWaitingRoomUseCases(GetIt scope, GetIt rootGetIt) {
  scope.registerFactory<AddVirtualPlayerUseCase>(
    () => AddVirtualPlayerUseCase(
      reservationsRepository: scope.get<WaitingRoomReservationsRepository>(),
      roomRepository: scope.get<WaitingRoomRoomRepository>(),
    ),
  );
  scope.registerFactory<LeaveWaitingRoomUseCase>(
    () => LeaveWaitingRoomUseCase(
      roomRepository: scope.get<WaitingRoomRoomRepository>(),
      appTransitionEventBus: rootGetIt<AppTransitionEventBus>(),
    ),
  );
  scope.registerFactory<ToggleLockWaitingRoomUseCase>(
    () => ToggleLockWaitingRoomUseCase(
      roomRepository: scope.get<WaitingRoomRoomRepository>(),
    ),
  );
  scope.registerFactory<ToggleDropInDropOutUseCase>(
    () => ToggleDropInDropOutUseCase(
      roomRepository: scope.get<WaitingRoomRoomRepository>(),
    ),
  );
  scope.registerFactory<KickPlayerUseCase>(
    () => KickPlayerUseCase(
      roomRepository: scope.get<WaitingRoomRoomRepository>(),
    ),
  );
  scope.registerFactory<StartWaitingRoomGameUseCase>(
    () => StartWaitingRoomGameUseCase(
      roomRepository: scope.get<WaitingRoomRoomRepository>(),
    ),
  );
}
