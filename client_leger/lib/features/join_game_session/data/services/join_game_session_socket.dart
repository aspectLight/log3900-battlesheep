import 'package:fpdart/fpdart.dart';

import '../../../../core/services/socket_service.dart';
import '../../core/exceptions/join_game_session_failure.dart'
    show JoinGameSessionFailure, UnknownJoinGameSessionFailure;
import '../../domain/commands/join_game_session_command.dart';
import '../../domain/result/join_room_result.dart';
import '../models/dto/join_room_response_dto.dart';
import '../models/extensions/join_room_response_dto_extensions.dart';
import '../models/events/join_game_session_socket_events.dart';

class JoinGameSessionSocket {
  JoinGameSessionSocket({required SocketService socketService})
      : _socketService = socketService;

  final SocketService _socketService;

  Future<Either<JoinGameSessionFailure, JoinRoomResult>> joinRoom(
    JoinGameSessionCommand command,
  ) async {
    final roomCode = command.roomCode;
    final socketId = command.socketId;
    final responseFuture = _socketService
        .on<Object?>(JoinGameSessionSocketEvents.joinRoomResponse)
        .first;
    _socketService.emit<String>(
      JoinGameSessionSocketEvents.joinWaitingRoom,
      roomCode,
    );
    final data = await responseFuture;
    final dto = data == null
        ? const JoinRoomResponseDto(success: false)
        : JoinRoomResponseDto.fromJson(data as Map<String, dynamic>);
    if (!dto.success) return left(dto.toFailure());
    final room = dto.room;
    if (room == null) {
      return left(const UnknownJoinGameSessionFailure(
        'Invalid join response: room missing',
      ));
    }
    return right(JoinRoomResult(
      roomCode: roomCode,
      socketId: socketId,
      hostId: room.hostId,
      initialRoom: room.toLobbyRoomModel(),
    ));
  }
}
