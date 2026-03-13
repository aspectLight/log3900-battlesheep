import 'package:json_annotation/json_annotation.dart';

part 'statistics_board_position_dto.g.dart';

@JsonSerializable()
class StatisticsBoardPositionDto {
  final int x;
  final int y;

  const StatisticsBoardPositionDto({required this.x, required this.y});

  factory StatisticsBoardPositionDto.fromJson(Map<String, dynamic> json) =>
      _$StatisticsBoardPositionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StatisticsBoardPositionDtoToJson(this);
}
