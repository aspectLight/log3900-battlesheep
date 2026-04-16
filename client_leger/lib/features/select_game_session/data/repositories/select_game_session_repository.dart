import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/constants/http_status.dart';
import '../../core/exceptions/select_game_session_failure.dart';
import '../../domain/models/game_info_model.dart';
import '../models/extensions/selectable_game_dto_extensions.dart';
import '../services/select_game_session_http_service.dart';

class SelectGameSessionRepository {
  final SelectGameSessionHttpService _httpService;

  SelectGameSessionRepository({
    required SelectGameSessionHttpService httpService,
  }) : _httpService = httpService;

  TaskEither<SelectGameSessionFailure, List<GameModelInfo>> loadGames() {
    return TaskEither<SelectGameSessionFailure, List<GameModelInfo>>.tryCatch(
      () async {
        final dtos = await _httpService.getGames();
        return dtos.map((dto) => dto.toModel()).toList();
      },
      _mapError,
    );
  }

  TaskEither<SelectGameSessionFailure, GameModelInfo> refreshGame(String id) {
    return TaskEither<SelectGameSessionFailure, GameModelInfo>.tryCatch(
      () async {
        final dto = await _httpService.getGameById(id);
        return dto.toModel();
      },
      _mapError,
    );
  }

  SelectGameSessionFailure _mapError(Object error, StackTrace stackTrace) {
    if (error is SelectGameSessionFailure) {
      return error;
    }
    if (error is DioException) {
      if (error.response?.statusCode == HttpStatus.notFound) {
        return const GameNotFoundSelectGameSessionFailure();
      }
      return const NetworkSelectGameSessionFailure();
    }
    return UnknownSelectGameSessionFailure(error.toString());
  }
}
