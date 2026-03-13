import 'package:freezed_annotation/freezed_annotation.dart';

part 'reserve_character_command.freezed.dart';

@freezed
class ReserveCharacterCommand with _$ReserveCharacterCommand {
  const factory ReserveCharacterCommand({
    required String roomId,
    required String chosenAvatar,
    required String playerId,
  }) = _ReserveCharacterCommand;
}
