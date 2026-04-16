import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_door_commands.freezed.dart';

@freezed
class ToggleDoorCommand with _$ToggleDoorCommand {
  const factory ToggleDoorCommand({
    required String roomId,
    required int x,
    required int y,
  }) = _ToggleDoorCommand;
}
