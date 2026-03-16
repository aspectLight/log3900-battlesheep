import 'package:json_annotation/json_annotation.dart';

import 'waiting_room_player_stat_value_dto.dart';

part 'waiting_room_player_stats_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class WaitingRoomPlayerStatsDto {
  const WaitingRoomPlayerStatsDto({
    required this.health,
    required this.speed,
    required this.attack,
    required this.defense,
  });

  final WaitingRoomPlayerStatValueDto health;
  final WaitingRoomPlayerStatValueDto speed;
  final WaitingRoomPlayerStatValueDto attack;
  final WaitingRoomPlayerStatValueDto defense;

  factory WaitingRoomPlayerStatsDto.fromJson(Map<String, dynamic> json) =>
      _$WaitingRoomPlayerStatsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WaitingRoomPlayerStatsDtoToJson(this);
}
