import 'package:fpdart/fpdart.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../core/exceptions/game_history_failure.dart';
import '../../domain/models/game_history_item.dart';
import '../../domain/state/game_history_state.dart';
import '../models/extensions/game_history_item_dto_extensions.dart';
import '../services/http_game_history_service.dart';

class GameHistoryRepository {
  GameHistoryRepository(this._service)
      : state = signal<GameHistoryState>(const GameHistoryState.idle());

  final HttpGameHistoryService _service;
  final Signal<GameHistoryState> state;

  Future<void> loadHistory() async {
    state.value = const GameHistoryState.loading();
    final result = await _loadHistoryTask().run();
    result.match(
      (_) => state.value = const GameHistoryState.loaded(items: []),
      (items) => state.value = GameHistoryState.loaded(items: items),
    );
  }

  TaskEither<GameHistoryFailure, List<GameHistoryItem>> _loadHistoryTask() {
    return TaskEither<GameHistoryFailure, List<GameHistoryItem>>.tryCatch(
      () async {
        final dtos = await _service.fetchGameHistory();
        return dtos.map((dto) => dto.toEntity()).toList();
      },
      _mapError,
    );
  }

  GameHistoryFailure _mapError(Object error, StackTrace stackTrace) {
    if (error is GameHistoryFailure) return error;
    return const LoadFailedGameHistoryFailure();
  }

  Future<String> startGameHistory(String mode) =>
      _service.startGameHistory(mode);

  Future<void> endGameHistory({
    required String startDate,
    required bool hasWon,
  }) async {
    await _service.endGameHistory(startDate: startDate, hasWon: hasWon);
  }

  Future<void> abandonGameHistory(String startDate) async {
    await _service.abandonGameHistory(startDate);
  }
}
