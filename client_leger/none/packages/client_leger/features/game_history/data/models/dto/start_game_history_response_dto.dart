import 'package:json_annotation/json_annotation.dart';

part 'start_game_history_response_dto.g.dart';

@JsonSerializable()
class StartGameHistoryResponseDto {
  final String startDate;

  const StartGameHistoryResponseDto({required this.startDate});

  factory StartGameHistoryResponseDto.fromJson(Map<String, dynamic> json) =>
      _$StartGameHistoryResponseDtoFromJson(json);
}
