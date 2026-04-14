import '../../../domain/events/character_creation_events.dart';
import '../dto/update_character_reserved_payload_dto.dart';
import 'reserved_character_item_dto_extensions.dart';

extension UpdateCharacterReservedPayloadDtoExtensions
    on UpdateCharacterReservedPayloadDto {
  List<ReservedCharacterEvent> toReservedCharacterEventList() =>
      reservedAvatars.map((d) => d.toReservedCharacterEvent()).toList();
}
