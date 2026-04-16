import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_debug_commands.freezed.dart';

@freezed
class ToggleDebugModeCommand with _$ToggleDebugModeCommand {
  const factory ToggleDebugModeCommand({required String roomId}) =
      _ToggleDebugModeCommand;
}
