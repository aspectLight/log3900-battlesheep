import 'package:json_annotation/json_annotation.dart';

part 'end_game_history_request_dto.g.dart';

@JsonSerializable()
class EndGameHistoryRequestDto {
  final String startDate;
  final bool hasWon;

  const EndGameHistoryRequestDto({
    required this.startDate,
    required this.hasWon,
  });

  factory EndGameHistoryRequestDto.fromJson(Map<String, dynamic> json) =>
      _$EndGameHistoryRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EndGameHistoryRequestDtoToJson(this);
}
