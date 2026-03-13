import 'package:json_annotation/json_annotation.dart';

part 'player_stat_value_dto.g.dart';

@JsonSerializable()
class PlayerStatValueDto {
  final int value;
  final int maxValue;
  final String description;

  const PlayerStatValueDto({
    required this.value,
    required this.maxValue,
    required this.description,
  });

  factory PlayerStatValueDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerStatValueDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerStatValueDtoToJson(this);
}
