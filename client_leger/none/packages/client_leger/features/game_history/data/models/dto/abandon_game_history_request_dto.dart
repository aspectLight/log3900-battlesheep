import 'package:json_annotation/json_annotation.dart';

part 'abandon_game_history_request_dto.g.dart';

@JsonSerializable()
class AbandonGameHistoryRequestDto {
  final String startDate;

  const AbandonGameHistoryRequestDto({required this.startDate});

  factory AbandonGameHistoryRequestDto.fromJson(Map<String, dynamic> json) =>
      _$AbandonGameHistoryRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AbandonGameHistoryRequestDtoToJson(this);
}
