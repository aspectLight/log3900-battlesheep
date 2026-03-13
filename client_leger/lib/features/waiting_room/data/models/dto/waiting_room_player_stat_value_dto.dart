import 'package:json_annotation/json_annotation.dart';

part 'waiting_room_player_stat_value_dto.g.dart';

@JsonSerializable()
class WaitingRoomPlayerStatValueDto {
  const WaitingRoomPlayerStatValueDto({
    required this.value,
    required this.maxValue,
    required this.description,
  });

  final int value;
  final int maxValue;
  final String description;

  factory WaitingRoomPlayerStatValueDto.fromJson(Map<String, dynamic> json) =>
      _$WaitingRoomPlayerStatValueDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WaitingRoomPlayerStatValueDtoToJson(this);
}
