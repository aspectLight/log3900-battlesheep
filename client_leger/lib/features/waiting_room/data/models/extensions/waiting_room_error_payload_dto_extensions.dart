import '../../../core/exceptions/waiting_room_failure.dart';
import '../dto/waiting_room_error_payload_dto.dart';

extension WaitingRoomErrorRawPayloadToDto on Object? {
  WaitingRoomErrorPayloadDto toWaitingRoomErrorPayloadDto() {
    if (this is String) {
      return WaitingRoomErrorPayloadDto(error: this! as String);
    }
    if (this is Map<String, dynamic>) {
      return WaitingRoomErrorPayloadDto.fromJson(this! as Map<String, dynamic>);
    }
    return const WaitingRoomErrorPayloadDto(
      error: 'Unknown waiting room error',
    );
  }
}

extension WaitingRoomErrorPayloadDtoToFailure on WaitingRoomErrorPayloadDto {
  WaitingRoomFailure toFailure() => error.toWaitingRoomFailure();
}

extension WaitingRoomServerMessageToFailure on String? {
  WaitingRoomFailure toWaitingRoomFailure() {
    if (this == null || this!.isEmpty) {
      return const UnknownWaitingRoomFailure('Unknown error');
    }
    final msg = this!;
    if (msg.contains("n'existe pas"))
      return const RoomNotFoundWaitingRoomFailure();
    if (msg.contains('est verrouillée'))
      return const RoomLockedWaitingRoomFailure();
    if (msg.contains('expulsé de la partie'))
      return const PlayerKickedWaitingRoomFailure();
    if (msg.contains('nombre maximum de joueurs')) {
      return const MaxPlayerLimitReachedWaitingRoomFailure();
    }
    return UnknownWaitingRoomFailure(msg);
  }
}
