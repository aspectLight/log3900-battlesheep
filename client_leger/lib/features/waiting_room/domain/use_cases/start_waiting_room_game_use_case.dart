import 'package:fpdart/fpdart.dart';

import '../../core/exceptions/waiting_room_failure.dart';
import '../../data/repositories/waiting_room_room_repository.dart';

class StartWaitingRoomGameUseCase {
  StartWaitingRoomGameUseCase({
    required WaitingRoomRoomRepository roomRepository,
  }) : _roomRepository = roomRepository;

  final WaitingRoomRoomRepository _roomRepository;

  Future<Either<WaitingRoomFailure, void>> execute() {
    return _roomRepository.startGame();
  }
}
