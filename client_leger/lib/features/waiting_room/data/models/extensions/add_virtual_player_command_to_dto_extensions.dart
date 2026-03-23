import '../../../domain/commands/add_virtual_player_command.dart';
import '../dto/create_player_payload_dto.dart';
import 'waiting_room_player_model_extensions.dart';

extension AddVirtualPlayerCommandToDto on AddVirtualPlayerCommand {
  CreatePlayerPayloadDto toCreatePlayerPayloadDto() => CreatePlayerPayloadDto(
        roomId: roomId,
        player: player.toDto(),
      );
}
