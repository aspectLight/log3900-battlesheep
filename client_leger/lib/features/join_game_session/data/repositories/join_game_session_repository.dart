import 'package:fpdart/fpdart.dart';

import '../../core/exceptions/join_game_session_failure.dart';
import '../../domain/commands/join_game_session_command.dart';
import '../../domain/models/available_room_model.dart';
import '../../domain/result/join_room_result.dart';
import '../services/join_game_session_socket.dart';

class JoinGameSessionRepository {
  JoinGameSessionRepository({required JoinGameSessionSocket socket})
      : _socket = socket;

  final JoinGameSessionSocket _socket;

  Future<Either<JoinGameSessionFailure, JoinRoomResult>> join(
    JoinGameSessionCommand command,
  ) => _socket.joinOrDropIn(command);

  Future<List<AvailableRoomModel>> getAvailableRooms() =>
      _socket.getAvailableRooms();
}
