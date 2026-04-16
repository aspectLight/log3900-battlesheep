import '../../../domain/commands/kick_player_command.dart';
import '../dto/kick_player_payload_dto.dart';
import 'waiting_room_player_model_extensions.dart';

extension KickPlayerCommandToDto on KickPlayerCommand {
  KickPlayerPayloadDto toKickPlayerPayloadDto() =>
      KickPlayerPayloadDto(roomId: roomId, player: player.toDto());
}
