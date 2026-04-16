import 'package:json_annotation/json_annotation.dart';

part 'waiting_room_player_stat_value_dto.g.dart';

@JsonSerializable(createFactory: false)
class WaitingRoomPlayerStatValueDto {
  const WaitingRoomPlayerStatValueDto({
    required this.value,
    required this.maxValue,
    required this.description,
  });

  final int value;
  final int maxValue;
  final String description;

  /// Angular StatInfo omits maxValue; default to the current value for cross-client rooms.
  factory WaitingRoomPlayerStatValueDto.fromJson(Map<String, dynamic> json) {
    final value = (json['value'] as num).toInt();
    final maxRaw = json['maxValue'];
    final maxValue = maxRaw is num ? maxRaw.toInt() : value;
    return WaitingRoomPlayerStatValueDto(
      value: value,
      maxValue: maxValue,
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => _$WaitingRoomPlayerStatValueDtoToJson(this);
}
