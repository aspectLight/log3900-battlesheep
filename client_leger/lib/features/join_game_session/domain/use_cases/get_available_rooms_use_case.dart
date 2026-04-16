import '../../data/repositories/join_game_session_repository.dart';
import '../models/available_room_model.dart';

class GetAvailableRoomsUseCase {
  GetAvailableRoomsUseCase({required JoinGameSessionRepository repository})
    : _repository = repository;

  final JoinGameSessionRepository _repository;

  Future<List<AvailableRoomModel>> execute() => _repository.getAvailableRooms();
}
