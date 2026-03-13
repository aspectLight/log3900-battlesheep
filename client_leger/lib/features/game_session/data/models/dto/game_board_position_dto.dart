import 'package:json_annotation/json_annotation.dart';

part 'game_board_position_dto.g.dart';

@JsonSerializable()
class GameBoardPositionDto {
  final int x;
  final int y;

  const GameBoardPositionDto({required this.x, required this.y});

  factory GameBoardPositionDto.fromJson(Map<String, dynamic> json) =>
      _$GameBoardPositionDtoFromJson(json);

  factory GameBoardPositionDto.fromDynamic(dynamic value) =>
      GameBoardPositionDto.fromJson(value as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$GameBoardPositionDtoToJson(this);
}
