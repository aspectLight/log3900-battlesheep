import 'package:json_annotation/json_annotation.dart';

part 'game_debug_dto.g.dart';

@JsonSerializable()
class ToggleDebugModeCommandDto {
  final String roomId;

  const ToggleDebugModeCommandDto({required this.roomId});

  factory ToggleDebugModeCommandDto.fromJson(Map<String, dynamic> json) =>
      _$ToggleDebugModeCommandDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ToggleDebugModeCommandDtoToJson(this);
}

class DebugModeEnabledDto {
  const DebugModeEnabledDto();

  factory DebugModeEnabledDto.fromObject(dynamic _) =>
      const DebugModeEnabledDto();

}

class DebugModeDisabledDto {
  const DebugModeDisabledDto();

  factory DebugModeDisabledDto.fromObject(dynamic _) =>
      const DebugModeDisabledDto();

}
