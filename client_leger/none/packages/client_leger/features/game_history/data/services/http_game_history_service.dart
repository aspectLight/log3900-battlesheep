import 'package:dio/dio.dart';

import '../../../../core/config/env_config.dart';
import '../../../../core/helpers/functional_programming.dart';
import '../../../authentication/core/interfaces/auth_repository.dart';
import '../../../authentication/domain/models/socket_auth_credentials.dart';
import '../../core/constants/game_history_api_endpoints.dart';
import '../models/dto/abandon_game_history_request_dto.dart';
import '../models/dto/end_game_history_request_dto.dart';
import '../models/dto/game_history_item_dto.dart';
import '../models/dto/start_game_history_request_dto.dart';
import '../models/dto/start_game_history_response_dto.dart';

Future<void> _completedFuture() => Future<void>.value();

class HttpGameHistoryService {
  final AuthRepository _authRepository;
  final Dio _dio;

  HttpGameHistoryService({required AuthRepository authRepository, Dio? dio})
    : _authRepository = authRepository,
      _dio = dio ?? Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));

  Options _authOptions(SocketAuthCredentialsModel creds) {
    return Options(
      headers: {
        'Authorization': 'Bearer ${creds.token}',
        'x-session-id': creds.sessionId,
      },
    );
  }

  Future<List<GameHistoryItemDto>> fetchGameHistory() async {
    final creds = _authRepository.getSocketAuthCredentials();
    return creds.when(
      none: () => <GameHistoryItemDto>[],
      some: (c) async {
        try {
          final response = await _dio.get<List<dynamic>>(
            GameHistoryApiEndpoints.gameHistory,
            options: _authOptions(c),
          );
          final data = response.data;
          if (data == null) return <GameHistoryItemDto>[];
          return data
              .map(
                (e) => GameHistoryItemDto.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        } on Object catch (_) {
          return <GameHistoryItemDto>[];
        }
      },
    );
  }

  Future<String> startGameHistory(String mode) async {
    final creds = _authRepository.getSocketAuthCredentials();
    return creds.when(
      none: () => '',
      some: (c) async {
        try {
          final response = await _dio.post<Map<String, dynamic>>(
            GameHistoryApiEndpoints.startGameHistory,
            data: StartGameHistoryRequestDto(mode: mode).toJson(),
            options: _authOptions(c),
          );
          final data = response.data;
          if (data == null) return '';
          final dto = StartGameHistoryResponseDto.fromJson(data);
          return dto.startDate;
        } on Object catch (_) {
          return '';
        }
      },
    );
  }

  Future<void> endGameHistory({
    required String startDate,
    required bool hasWon,
  }) async {
    final creds = _authRepository.getSocketAuthCredentials();
    await creds.when(
      none: _completedFuture,
      some: (c) async {
        try {
          await _dio.post<void>(
            GameHistoryApiEndpoints.endGameHistory,
            data: EndGameHistoryRequestDto(
              startDate: startDate,
              hasWon: hasWon,
            ).toJson(),
            options: _authOptions(c),
          );
        } on Object catch (_) {}
      },
    );
  }

  Future<void> abandonGameHistory(String startDate) async {
    final creds = _authRepository.getSocketAuthCredentials();
    await creds.when(
      none: _completedFuture,
      some: (c) async {
        try {
          await _dio.post<void>(
            GameHistoryApiEndpoints.abandonGameHistory,
            data: AbandonGameHistoryRequestDto(startDate: startDate).toJson(),
            options: _authOptions(c),
          );
        } on Object catch (_) {}
      },
    );
  }
}
