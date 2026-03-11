enum LogType { login, logout }

class LogsHistoryItem {
  final LogType type;
  final DateTime date;

  const LogsHistoryItem({required this.type, required this.date});

  factory LogsHistoryItem.fromJson(Map<String, dynamic> json) {
    return LogsHistoryItem(
      type: json['type'] == 'login' ? LogType.login : LogType.logout,
      date: DateTime.parse(json['date'] as String),
    );
  }
}
