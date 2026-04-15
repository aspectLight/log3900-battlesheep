import '../../../domain/events/character_creation_events.dart';
import '../dto/reserved_character_item_dto.dart';

extension ReservedCharacterItemDtoExtensions on ReservedCharacterItemDto {
  ReservedCharacterEvent toReservedCharacterEvent() => ReservedCharacterEvent(
    reservorId: reservorId,
    chosenAvatar: chosenAvatar,
  );
}
