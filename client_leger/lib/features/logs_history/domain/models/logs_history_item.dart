import '../../core/enums/log_type.dart';

class LogsHistoryItem {
  final LogType type;
  final DateTime date;

  const LogsHistoryItem({required this.type, required this.date});
}
