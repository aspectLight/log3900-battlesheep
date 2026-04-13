import 'package:dio/dio.dart';

import '../../../../core/config/env_config.dart';
import '../../../authentication/core/interfaces/auth_repository.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/dto/game_summary_dto.dart';

class SelectGameSessionHttpService {
  SelectGameSessionHttpService({
    required AuthRepository authRepository,
    Dio? dio,
  })  : _authRepository = authRepository,
        _dio = dio ?? Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));

  final AuthRepository _authRepository;
  final Dio _dio;

  Options _authOptions() {
    final creds = _authRepository.getSocketAuthCredentials();
    return creds.match(
      () => throw StateError('Not authenticated'),
      (c) => Options(
        headers: {
          'Authorization': 'Bearer ${c.token}',
          'x-session-id': c.sessionId,
        },
      ),
    );
  }

  Future<List<GameSummaryDto>> getGames() async {
    final response = await _dio.get<List<dynamic>>(
      SelectGameSessionApiEndpoints.games,
      queryParameters: const {'purpose': 'play'},
      options: _authOptions(),
    );
    final data = response.data ?? <dynamic>[];
    return data
        .whereType<Map<String, dynamic>>()
        .map(GameSummaryDto.fromJson)
        .toList();
  }

  Future<GameSummaryDto> getGameById(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${SelectGameSessionApiEndpoints.games}/$id',
      options: _authOptions(),
    );
    final Map<String, dynamic>? data = response.data;
    if (data == null) {
      throw Exception('Empty response body for game details');
    }
    return GameSummaryDto.fromJson(data);
  }
}
