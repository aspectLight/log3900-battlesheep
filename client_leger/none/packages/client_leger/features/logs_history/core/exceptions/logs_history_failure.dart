sealed class LogsHistoryFailure implements Exception {
  final String devMessage;

  const LogsHistoryFailure(this.devMessage);

  @override
  String toString() => devMessage;
}

class LoadFailedLogsHistoryFailure extends LogsHistoryFailure {
  const LoadFailedLogsHistoryFailure()
    : super('Failed to load connection history');
}

class UnknownLogsHistoryFailure extends LogsHistoryFailure {
  const UnknownLogsHistoryFailure(super.devMessage);
}
