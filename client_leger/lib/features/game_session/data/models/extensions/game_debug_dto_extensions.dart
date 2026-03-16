import '../../../domain/commands/game_debug_commands.dart';
import '../../../domain/events/game_debug_events.dart';
import '../dto/game_debug_dto.dart';

extension ToggleDebugModeCommandToDto on ToggleDebugModeCommand {
  ToggleDebugModeCommandDto toDto() =>
      ToggleDebugModeCommandDto(roomId: roomId);
}

extension DebugModeEnabledDtoToEntity on DebugModeEnabledDto {
  DebugModeEnabledEvent toEntity() => const DebugModeEnabledEvent();
}

extension DebugModeDisabledDtoToEntity on DebugModeDisabledDto {
  DebugModeDisabledEvent toEntity() => const DebugModeDisabledEvent();
}
