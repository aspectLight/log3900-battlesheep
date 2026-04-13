import '../../../domain/commands/create_character_commands.dart';
import '../dto/create_player_request_dto.dart';
import '../dto/create_waiting_room_request_dto.dart';
import 'create_character_player_data_to_dto_extensions.dart';

extension CreateCharacterCommandToDto on CreateCharacterCommand {
  CreatePlayerRequestDto toCreatePlayerRequestDto() =>
      CreatePlayerRequestDto(roomId: roomId, player: player.toDto());
}

extension CreateWaitingRoomCommandToDto on CreateWaitingRoomCommand {
  CreateWaitingRoomRequestDto toCreateWaitingRoomRequestDto() =>
      CreateWaitingRoomRequestDto(
        roomId: roomCode,
        gameId: gameId,
        host: host.toDto(),
        entryFee: entryFee,
      );
}
