import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../core/config/env_config.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/exceptions/history_exception.dart';
import '../../core/session/session_credentials.dart';
import '../../domain/interfaces/services/history_service.dart';
import '../models/game_history_item_dto.dart';
import '../models/logs_history_item_dto.dart';
import 'log_service.dart';

class HttpHistoryService implements HistoryService {
  final Dio _dio;
  final SessionCredentials _credentials;

  HttpHistoryService({required SessionCredentials credentials, Dio? dio})
    : _credentials = credentials,
      _dio = dio ?? Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));

  Options _getAuthOptions() {
    final headers = <String, dynamic>{};
    if (_credentials.token != null) {
      headers['Authorization'] = 'Bearer ${_credentials.token}';
    }
    if (_credentials.sessionId != null) {
      headers['x-session-id'] = _credentials.sessionId;
    }
    return Options(headers: headers);
  }

  @override
  TaskEither<HistoryException, List<LogsHistoryItemDto>> fetchLoginHistory() =>
      TaskEither.tryCatch(() async {
        LogService.d('Fetching login history');
        final response = await _dio.get<List<dynamic>>(
          ApiEndpoints.loginHistory,
          options: _getAuthOptions(),
        );
        final data = response.data;
        if (data == null) {
          throw const HistoryServerException(
            devMessage: 'Login history response is null',
          );
        }
        return data
            .map(
              (json) =>
                  LogsHistoryItemDto.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      }, _onError);

  @override
  TaskEither<HistoryException, List<GameHistoryItemDto>> fetchGameHistory() =>
      TaskEither.tryCatch(() async {
        LogService.d('Fetching game history');
        final response = await _dio.get<List<dynamic>>(
          ApiEndpoints.gameHistory,
          options: _getAuthOptions(),
        );
        final data = response.data;
        if (data == null) {
          throw const HistoryServerException(
            devMessage: 'Game history response is null',
          );
        }
        return data
            .map(
              (json) =>
                  GameHistoryItemDto.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      }, _onError);

  @override
  TaskEither<HistoryException, String> startGameHistory(String mode) =>
      TaskEither.tryCatch(() async {
        final response = await _dio.post<Map<String, dynamic>>(
          ApiEndpoints.startGameHistory,
          data: {'mode': mode},
          options: _getAuthOptions(),
        );
        return response.data!['startDate'] as String;
      }, _onError);

  @override
  TaskEither<HistoryException, Unit> endGameHistory({
    required String startDate,
    required bool hasWon,
  }) => TaskEither.tryCatch(() async {
    await _dio.post<void>(
      ApiEndpoints.endGameHistory,
      data: {'startDate': startDate, 'hasWon': hasWon},
      options: _getAuthOptions(),
    );
    return unit;
  }, _onError);

  @override
  TaskEither<HistoryException, Unit> abandonGameHistory(String startDate) =>
      TaskEither.tryCatch(() async {
        await _dio.post<void>(
          ApiEndpoints.abandonGameHistory,
          data: {'startDate': startDate},
          options: _getAuthOptions(),
        );
        return unit;
      }, _onError);

  HistoryException _onError(Object error, StackTrace stackTrace) {
    if (error is HistoryException) return error;
    if (error is DioException) return _handleDioError(error);
    return UnknownHistoryException(error.toString());
  }

  HistoryException _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return const HistoryNetworkException();
    }
    final response = error.response;
    if (response != null) {
      LogService.e('Received Error Response: ${response.statusCode}');
      return HistoryServerException(
        statusCode: response.statusCode,
        devMessage: 'Server error: ${response.statusCode}',
      );
    }
    return const HistoryNetworkException();
  }
}
