import '../../../domain/commands/create_waiting_room_command.dart';
import '../dto/create_waiting_room_payload_dto.dart';
import 'waiting_room_player_model_extensions.dart';

extension CreateWaitingRoomCommandToDto on CreateWaitingRoomCommand {
  CreateWaitingRoomPayloadDto toCreateWaitingRoomPayloadDto() =>
      CreateWaitingRoomPayloadDto(
        roomId: roomId,
        gameId: gameId,
        host: host.toDto(),
      );
}
