import 'package:json_annotation/json_annotation.dart';

part 'logs_history_item_dto.g.dart';

@JsonSerializable()
class LogsHistoryItemDto {
  final String type;
  final String date;

  const LogsHistoryItemDto({required this.type, required this.date});

  factory LogsHistoryItemDto.fromJson(Map<String, dynamic> json) =>
      _$LogsHistoryItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LogsHistoryItemDtoToJson(this);
}
