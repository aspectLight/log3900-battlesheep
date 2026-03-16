import 'package:json_annotation/json_annotation.dart';

part 'start_game_history_request_dto.g.dart';

@JsonSerializable()
class StartGameHistoryRequestDto {
  final String mode;

  const StartGameHistoryRequestDto({required this.mode});

  factory StartGameHistoryRequestDto.fromJson(Map<String, dynamic> json) =>
      _$StartGameHistoryRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StartGameHistoryRequestDtoToJson(this);
}
