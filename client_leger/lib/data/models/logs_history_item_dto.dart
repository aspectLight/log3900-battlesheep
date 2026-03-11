import '../../domain/entities/logs_history_item.dart';

class LogsHistoryItemDto {
  final String type;
  final String date;

  const LogsHistoryItemDto({required this.type, required this.date});

  factory LogsHistoryItemDto.fromJson(Map<String, dynamic> json) {
    return LogsHistoryItemDto(
      type: json['type'] as String,
      date: json['date'] as String,
    );
  }

  LogsHistoryItem toEntity() => LogsHistoryItem(
    type: type == 'login' ? LogType.login : LogType.logout,
    date: DateTime.parse(date).toLocal(),
  );
}
