import '../../../domain/commands/get_reserved_characters_command.dart';
import '../dto/get_reserved_characters_request_dto.dart';

extension GetReservedCharactersCommandToDto on GetReservedCharactersCommand {
  GetReservedCharactersRequestDto toGetReservedCharactersRequestDto() =>
      GetReservedCharactersRequestDto(roomId: roomId);
}
