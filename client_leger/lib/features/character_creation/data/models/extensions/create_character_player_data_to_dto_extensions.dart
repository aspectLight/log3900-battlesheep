import '../../../core/enums/character_creation_bonus_choice.dart';
import '../../../core/enums/character_creation_dice_stat_choice.dart';
import '../../../core/enums/character_creation_stat_key.dart';
import '../../../domain/commands/create_character_commands.dart';
import '../dto/avatar_name_dto.dart';
import '../dto/player_payload_dto.dart';
import '../dto/player_stat_value_dto.dart';

extension CreateCharacterPlayerDataToDto on CreateCharacterPlayerData {
  PlayerPayloadDto toDto() => PlayerPayloadDto(
    name: name,
    avatar: AvatarNameDto(name: characterId),
    bonusChoice: bonusChoice.toServerValue,
    d6Choice: d6Choice.toServerValue,
    d4Choice: d4Choice.toServerValue,
    inventory: _createServerCompatibleEmptyInventory(),
    stats: {
      CharacterCreationStatKey.health.toServerValue:
          _createServerCompatibleFixedStat(health),
      CharacterCreationStatKey.speed.toServerValue:
          _createServerCompatibleFixedStat(speed),
      CharacterCreationStatKey.attack.toServerValue:
          _createServerCompatibleFixedStat(attackDice),
      CharacterCreationStatKey.defense.toServerValue:
          _createServerCompatibleFixedStat(defenseDice),
    },
    activeBanner: activeBanner,
  );
}

List<PlayerInventoryItemDto> _createServerCompatibleEmptyInventory() {
  return const [];
}

PlayerStatValueDto _createServerCompatibleFixedStat(int value) {
  return PlayerStatValueDto(value: value, maxValue: value, description: '');
}
