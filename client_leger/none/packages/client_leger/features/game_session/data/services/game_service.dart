import 'package:dio/dio.dart';

import '../../../authentication/core/interfaces/auth_repository.dart';
import '../../../authentication/domain/models/socket_auth_credentials.dart';
import '../../core/constants/api_endpoints.dart';
import '../../domain/models/game.dart';
import '../models/dto/game_dto.dart';
import '../models/extensions/game_dto_extensions.dart';

class GameService {
  final Dio _dio;
  final AuthRepository _authRepository;

  GameService(this._dio, this._authRepository);

  Options _authOptions(SocketAuthCredentialsModel creds) {
    return Options(
      headers: {
        'Authorization': 'Bearer ${creds.token}',
        'x-session-id': creds.sessionId,
      },
    );
  }

  Future<Game> getGame(String gameId) async {
    final credentials = _authRepository.getSocketAuthCredentials();
    final response = await _dio.get<Map<String, dynamic>>(
      '${GameApiEndpoints.games}/$gameId',
      options: credentials.match(() => null, _authOptions),
    );
    final data = response.data;
    if (data == null) {
      throw Exception('Server returned null for game $gameId');
    }
    return GameDto.fromJson(data).toEntity();
  }
}
