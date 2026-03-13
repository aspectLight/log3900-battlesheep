import 'package:dio/dio.dart';

import '../../core/constants/api_endpoints.dart';
import '../../domain/models/game.dart';
import '../models/dto/game_dto.dart';
import '../models/extensions/game_dto_extensions.dart';

class GameService {
  final Dio _dio;

  GameService(this._dio);

  Future<Game> getGame(String gameId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${GameApiEndpoints.games}/$gameId',
    );
    final data = response.data;
    if (data == null) {
      throw Exception('Server returned null for game $gameId');
    }
    return GameDto.fromJson(data).toEntity();
  }
}
