import 'package:json_annotation/json_annotation.dart';

part 'game_history_item_dto.g.dart';

@JsonSerializable()
class GameHistoryItemDto {
  final String startDate;
  final String mode;
  final bool hasWon;
  final bool hasAbandoned;

  const GameHistoryItemDto({
    required this.startDate,
    required this.mode,
    required this.hasWon,
    required this.hasAbandoned,
  });

  factory GameHistoryItemDto.fromJson(Map<String, dynamic> json) =>
      _$GameHistoryItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GameHistoryItemDtoToJson(this);
}
