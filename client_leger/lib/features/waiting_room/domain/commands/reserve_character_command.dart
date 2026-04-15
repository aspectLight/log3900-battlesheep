import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/character.dart';

part 'reserve_character_command.freezed.dart';

@freezed
class ReserveCharacterCommand with _$ReserveCharacterCommand {
  const factory ReserveCharacterCommand({
    required String roomId,
    required Character chosenCharacter,
    required String playerId,
  }) = _ReserveCharacterCommand;
}
