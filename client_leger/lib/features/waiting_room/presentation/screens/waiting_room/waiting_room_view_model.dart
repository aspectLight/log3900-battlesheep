import 'package:signals_flutter/signals_flutter.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../core/enums/virtual_player_type.dart';
import '../../../../../core/helpers/functional_programming.dart';
import '../../../core/exceptions/waiting_room_failure.dart';
import '../../../core/typedefs/waiting_room_start_validation_params.dart';
import '../../../core/helpers/waiting_room_start_validation.dart';
import '../../../data/repositories/waiting_room_room_repository.dart';
import '../../../domain/models/waiting_room_model.dart';
import '../../../domain/models/waiting_room_player_model.dart';
import '../../../domain/use_cases/add_virtual_player_use_case.dart';
import '../../../domain/use_cases/kick_player_use_case.dart';
import '../../../domain/use_cases/leave_waiting_room_use_case.dart';
import '../../../domain/use_cases/start_waiting_room_game_use_case.dart';
import '../../../domain/use_cases/toggle_lock_waiting_room_use_case.dart';

class WaitingRoomViewModel {
  WaitingRoomViewModel({
    required WaitingRoomRoomRepository roomRepository,
    required WaitingRoomStartValidationParams startParams,
    required AddVirtualPlayerUseCase addVirtualPlayerUseCase,
    required LeaveWaitingRoomUseCase leaveWaitingRoomUseCase,
    required ToggleLockWaitingRoomUseCase toggleLockWaitingRoomUseCase,
    required KickPlayerUseCase kickPlayerUseCase,
    required StartWaitingRoomGameUseCase startWaitingRoomGameUseCase,
  })  : _roomRepository = roomRepository,
        _startParams = startParams,
        _addVirtualPlayerUseCase = addVirtualPlayerUseCase,
        _leaveWaitingRoomUseCase = leaveWaitingRoomUseCase,
        _toggleLockWaitingRoomUseCase = toggleLockWaitingRoomUseCase,
        _kickPlayerUseCase = kickPlayerUseCase,
        _startWaitingRoomGameUseCase = startWaitingRoomGameUseCase;

  final WaitingRoomRoomRepository _roomRepository;
  final WaitingRoomStartValidationParams _startParams;
  final AddVirtualPlayerUseCase _addVirtualPlayerUseCase;
  final LeaveWaitingRoomUseCase _leaveWaitingRoomUseCase;
  final ToggleLockWaitingRoomUseCase _toggleLockWaitingRoomUseCase;
  final KickPlayerUseCase _kickPlayerUseCase;
  final StartWaitingRoomGameUseCase _startWaitingRoomGameUseCase;

  late final room = computed<WaitingRoomModel>(
    () => _roomRepository.state.value.room,
  );
  late final isHost = computed<bool>(() => _roomRepository.state.value.isHost);
  late final isStartValid = computed<bool>(
    () => isWaitingRoomStartValid(room.value, _startParams),
  );
  late final canAddVirtualPlayer = computed<bool>(
    () => !shouldBlockLockByPlayerLimit(room.value, _startParams),
  );
  late final isAtMaxPlayers = computed<bool>(
    () => isWaitingRoomAtMaxPlayers(room.value, _startParams),
  );

  Future<Option<WaitingRoomFailure>> leaveRoom() async {
    final result = await _leaveWaitingRoomUseCase.execute();
    Option<WaitingRoomFailure> failureOption = none();
    result.when(
      left: (failure) {
        failureOption = Option.of(failure);
      },
    );
    return failureOption;
  }

  Future<Option<WaitingRoomFailure>> toggleLock() async {
    if (!isHost.value) return none();
    final currentRoom = room.value;
    if (currentRoom.isLocked && isWaitingRoomAtMaxPlayers(currentRoom, _startParams)) {
      return const Option.of(MaxPlayerLimitReachedWaitingRoomFailure());
    }
    _toggleLockWaitingRoomUseCase.execute();
    return none();
  }

  Future<Option<WaitingRoomFailure>> kickPlayer(
    WaitingRoomPlayerModel player,
  ) {
    if (!isHost.value) return Future.value(none());
    _kickPlayerUseCase.execute(player);
    return Future.value(none());
  }

  Future<Option<WaitingRoomFailure>> addVirtualPlayer({
    required VirtualPlayerType virtualType,
  }) async {
    if (!isHost.value) return none();
    final result = await _addVirtualPlayerUseCase.execute(
      virtualType: virtualType,
    );
    Option<WaitingRoomFailure> failureOption = none();
    result.when(
      left: (failure) {
        failureOption = Option.of(failure);
      },
    );
    return failureOption;
  }

  Future<Option<WaitingRoomFailure>> startGame() async {
    if (!isHost.value || !isStartValid.value) return none();
    final result = await _startWaitingRoomGameUseCase.execute();
    Option<WaitingRoomFailure> failureOption = none();
    result.when(
      left: (failure) {
        failureOption = Option.of(failure);
      },
    );
    return failureOption;
  }
}
