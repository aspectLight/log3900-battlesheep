import 'package:fpdart/fpdart.dart';

import '../../core/exceptions/history_exception.dart';
import '../../core/failures/failure.dart';
import '../../domain/entities/game_history_item.dart';
import '../../domain/interfaces/repositories/game_history_repository.dart';
import '../../domain/interfaces/services/history_service.dart';

class GameHistoryRepositoryImpl implements GameHistoryRepository {
  final HistoryService _service;

  const GameHistoryRepositoryImpl(this._service);

  @override
  TaskEither<Failure, List<GameHistoryItem>> getGameHistory() =>
      TaskEither.tryCatch(() async {
        final result = await _service.fetchGameHistory().run();
        final dtos = result.getOrElse((l) => throw l);
        return dtos.map((dto) => dto.toEntity()).toList();
      }, _onError);

  @override
  TaskEither<Failure, String> startGameHistory(String mode) =>
      TaskEither.tryCatch(() async {
        final result = await _service.startGameHistory(mode).run();
        return result.getOrElse((l) => throw l);
      }, _onError);

  @override
  TaskEither<Failure, Unit> endGameHistory({
    required String startDate,
    required bool hasWon,
  }) => TaskEither.tryCatch(() async {
    final result = await _service
        .endGameHistory(startDate: startDate, hasWon: hasWon)
        .run();
    return result.getOrElse((l) => throw l);
  }, _onError);

  @override
  TaskEither<Failure, Unit> abandonGameHistory(String startDate) =>
      TaskEither.tryCatch(() async {
        final result = await _service.abandonGameHistory(startDate).run();
        return result.getOrElse((l) => throw l);
      }, _onError);

  Failure _onError(Object error, StackTrace stackTrace) {
    if (error is HistoryException) return NetworkFailure(error.toString());
    return UnknownFailure(error.toString());
  }
}
