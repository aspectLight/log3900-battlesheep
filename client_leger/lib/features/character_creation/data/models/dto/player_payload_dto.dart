import 'package:json_annotation/json_annotation.dart';

import 'avatar_name_dto.dart';
import 'player_stat_value_dto.dart';

part 'player_payload_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class PlayerPayloadDto {
  final String name;
  final AvatarNameDto avatar;
  final String bonusChoice;
  final String d6Choice;
  final String d4Choice;
  final List<PlayerInventoryItemDto> inventory;
  final Map<String, PlayerStatValueDto> stats;

  const PlayerPayloadDto({
    required this.name,
    required this.avatar,
    required this.bonusChoice,
    required this.d6Choice,
    required this.d4Choice,
    required this.inventory,
    required this.stats,
  });

  factory PlayerPayloadDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerPayloadDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerPayloadDtoToJson(this);
}

@JsonSerializable()
class PlayerInventoryItemDto {
  final String type;

  const PlayerInventoryItemDto({required this.type});

  factory PlayerInventoryItemDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerInventoryItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerInventoryItemDtoToJson(this);
}
