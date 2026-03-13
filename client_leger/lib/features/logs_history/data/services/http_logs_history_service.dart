import 'package:dio/dio.dart';

import '../../../../core/config/env_config.dart';
import '../../../../core/helpers/functional_programming.dart';
import '../../../authentication/core/interfaces/auth_repository.dart';
import '../models/dto/logs_history_item_dto.dart';
import '../../core/constants/logs_history_api_endpoints.dart';

class HttpLogsHistoryService {
  final AuthRepository _authRepository;
  final Dio _dio;

  HttpLogsHistoryService({
    required AuthRepository authRepository,
    Dio? dio,
  })  : _authRepository = authRepository,
        _dio = dio ?? Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));

  Options _authOptions(String token, String sessionId) {
    return Options(
      headers: {
        'Authorization': 'Bearer $token',
        'x-session-id': sessionId,
      },
    );
  }

  Future<List<LogsHistoryItemDto>> fetchLoginHistory() async {
    final creds = _authRepository.getSocketAuthCredentials();
    return creds.when(
      none: () => <LogsHistoryItemDto>[],
      some: (c) async {
        try {
          final response = await _dio.get<List<dynamic>>(
            LogsHistoryApiEndpoints.loginHistory,
            options: _authOptions(c.token, c.sessionId),
          );
          final data = response.data;
          if (data == null) return <LogsHistoryItemDto>[];
          return data
              .map(
                (e) =>
                    LogsHistoryItemDto.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        } on Object catch (_) {
          return <LogsHistoryItemDto>[];
        }
      },
    );
  }
}
