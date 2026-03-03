import 'package:fpdart/fpdart.dart';

import '../../core/exceptions/history_exception.dart';
import '../../core/failures/failure.dart';
import '../../domain/entities/logs_history_item.dart';
import '../../domain/interfaces/repositories/logs_history_repository.dart';
import '../../domain/interfaces/services/history_service.dart';

class LogsHistoryRepositoryImpl implements LogsHistoryRepository {
  final HistoryService _service;

  const LogsHistoryRepositoryImpl(this._service);

  @override
  TaskEither<Failure, List<LogsHistoryItem>> getLoginHistory() =>
      TaskEither.tryCatch(() async {
        final result = await _service.fetchLoginHistory().run();
        final dtos = result.getOrElse((l) => throw l);
        return dtos.map((dto) => dto.toEntity()).toList();
      }, _onError);

  Failure _onError(Object error, StackTrace stackTrace) {
    if (error is HistoryException) return NetworkFailure(error.toString());
    return UnknownFailure(error.toString());
  }
}
