import 'package:fpdart/fpdart.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../core/exceptions/logs_history_failure.dart';
import '../../domain/models/logs_history_item.dart';
import '../../domain/state/logs_history_state.dart';
import '../models/extensions/logs_history_item_dto_extensions.dart';
import '../services/http_logs_history_service.dart';

class LogsHistoryRepository {
  LogsHistoryRepository(this._service)
      : state = signal<LogsHistoryState>(const LogsHistoryState.idle());

  final HttpLogsHistoryService _service;
  final Signal<LogsHistoryState> state;

  Future<void> loadHistory() async {
    state.value = const LogsHistoryState.loading();
    final result = await _loadHistoryTask().run();
    result.match(
      (_) => state.value = const LogsHistoryState.loaded(items: []),
      (items) => state.value = LogsHistoryState.loaded(items: items),
    );
  }

  TaskEither<LogsHistoryFailure, List<LogsHistoryItem>> _loadHistoryTask() {
    return TaskEither<LogsHistoryFailure, List<LogsHistoryItem>>.tryCatch(
      () async {
        final dtos = await _service.fetchLoginHistory();
        return dtos.map((dto) => dto.toEntity()).toList();
      },
      _mapError,
    );
  }

  LogsHistoryFailure _mapError(Object error, StackTrace stackTrace) {
    if (error is LogsHistoryFailure) return error;
    return const LoadFailedLogsHistoryFailure();
  }
}
