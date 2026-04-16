import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/enums/character_creation_bonus_choice.dart';
import '../../core/enums/character_creation_dice_stat_choice.dart';

part 'create_character_commands.freezed.dart';

@freezed
class CreateCharacterPlayerData with _$CreateCharacterPlayerData {
  const factory CreateCharacterPlayerData({
    required String name,
    required String characterId,
    required CharacterCreationBonusChoice bonusChoice,
    required CharacterCreationDiceStatChoice d6Choice,
    required CharacterCreationDiceStatChoice d4Choice,
    required int health,
    required int speed,
    required int attackDice,
    required int defenseDice,
    String? activeBanner,
  }) = _CreateCharacterPlayerData;
}

@freezed
class CreateCharacterCommand with _$CreateCharacterCommand {
  const factory CreateCharacterCommand({
    required String roomId,
    required CreateCharacterPlayerData player,
  }) = _CreateCharacterCommand;
}

@freezed
class CreateWaitingRoomCommand with _$CreateWaitingRoomCommand {
  const factory CreateWaitingRoomCommand({
    required String roomCode,
    required String gameId,
    required CreateCharacterPlayerData host,
    @Default(0) int entryFee,
    @Default(false) bool friendsOnly,
  }) = _CreateWaitingRoomCommand;
}
