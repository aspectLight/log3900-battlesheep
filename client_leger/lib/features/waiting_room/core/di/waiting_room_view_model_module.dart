import 'package:get_it/get_it.dart';

import '../typedefs/waiting_room_start_validation_params.dart';
import '../../../shop/data/repositories/shop_repository.dart';
import '../../data/repositories/waiting_room_room_repository.dart';
import '../../domain/use_cases/add_virtual_player_use_case.dart';
import '../../domain/use_cases/kick_player_use_case.dart';
import '../../domain/use_cases/leave_waiting_room_use_case.dart';
import '../../domain/use_cases/start_waiting_room_game_use_case.dart';
import '../../domain/use_cases/toggle_drop_in_drop_out_use_case.dart';
import '../../domain/use_cases/toggle_lock_waiting_room_use_case.dart';
import '../../presentation/screens/waiting_room/waiting_room_view_model.dart';

void registerWaitingRoomScopeViewModels(GetIt scope, GetIt rootGetIt) {
  scope.registerFactory<WaitingRoomViewModel>(
    () => WaitingRoomViewModel(
      roomRepository: scope.get<WaitingRoomRoomRepository>(),
      startParams: scope.get<WaitingRoomStartValidationParams>(),
      addVirtualPlayerUseCase: scope.get<AddVirtualPlayerUseCase>(),
      leaveWaitingRoomUseCase: scope.get<LeaveWaitingRoomUseCase>(),
      toggleLockWaitingRoomUseCase: scope.get<ToggleLockWaitingRoomUseCase>(),
      toggleDropInDropOutUseCase: scope.get<ToggleDropInDropOutUseCase>(),
      kickPlayerUseCase: scope.get<KickPlayerUseCase>(),
      startWaitingRoomGameUseCase: scope.get<StartWaitingRoomGameUseCase>(),
      shopRepository: scope.get<ShopRepository>(),
    ),
  );
}
