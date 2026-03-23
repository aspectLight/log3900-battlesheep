import '../../../domain/commands/get_reserved_characters_command.dart';
import '../dto/get_reserved_characters_command_dto.dart';

extension GetReservedCharactersCommandToDto on GetReservedCharactersCommand {
  GetReservedCharactersCommandDto toGetReservedCharactersCommandDto() =>
      GetReservedCharactersCommandDto(roomId: roomId);
}
