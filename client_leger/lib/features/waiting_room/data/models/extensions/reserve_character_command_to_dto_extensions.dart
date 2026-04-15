import '../../../domain/commands/reserve_character_command.dart';
import '../dto/reserve_character_command_dto.dart';

extension ReserveCharacterCommandToDto on ReserveCharacterCommand {
  ReserveCharacterCommandDto toReserveCharacterCommandDto() =>
      ReserveCharacterCommandDto(
        roomId: roomId,
        chosenCharacter: chosenCharacter,
        playerId: playerId,
        isVirtual: isVirtual,
      );
}
