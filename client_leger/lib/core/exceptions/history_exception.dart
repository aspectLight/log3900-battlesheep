abstract class HistoryException implements Exception {
  const HistoryException();
}

class HistoryNetworkException extends HistoryException {
  const HistoryNetworkException();
}

class HistoryServerException extends HistoryException {
  final int? statusCode;
  final String devMessage;
  const HistoryServerException({this.statusCode, required this.devMessage});
}

class UnknownHistoryException extends HistoryException {
  final String message;
  const UnknownHistoryException(this.message);
}
