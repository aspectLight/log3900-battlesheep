import 'package:dio/dio.dart';

import '../../../../core/config/env_config.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/dto/game_summary_dto.dart';

class SelectGameSessionHttpService {
  final Dio _dio;

  SelectGameSessionHttpService({Dio? dio})
    : _dio = dio ?? Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));

  Future<List<GameSummaryDto>> getGames() async {
    final response = await _dio.get<List<dynamic>>(SelectGameSessionApiEndpoints.games);
    final data = response.data ?? <dynamic>[];
    return data
        .whereType<Map<String, dynamic>>()
        .map(GameSummaryDto.fromJson)
        .toList();
  }

  Future<GameSummaryDto> getGameById(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${SelectGameSessionApiEndpoints.games}/$id',
    );
    final Map<String, dynamic>? data = response.data;
    if (data == null) {
      throw Exception('Empty response body for game details');
    }
    return GameSummaryDto.fromJson(data);
  }
}

