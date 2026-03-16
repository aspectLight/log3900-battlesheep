import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/exceptions/logs_history_failure.dart';
import '../models/logs_history_item.dart';

part 'logs_history_state.freezed.dart';

@freezed
sealed class LogsHistoryState with _$LogsHistoryState {
  const factory LogsHistoryState.idle() = LogsHistoryStateIdle;

  const factory LogsHistoryState.loading() = LogsHistoryStateLoading;

  const factory LogsHistoryState.loaded({
    required List<LogsHistoryItem> items,
  }) = LogsHistoryStateLoaded;

  const factory LogsHistoryState.error(
    LogsHistoryFailure failure,
  ) = LogsHistoryStateError;
}
