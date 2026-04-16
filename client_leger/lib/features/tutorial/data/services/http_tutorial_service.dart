import 'package:dio/dio.dart';

import '../../../../core/config/env_config.dart';
import '../../../../core/helpers/functional_programming.dart';
import '../../../authentication/core/interfaces/auth_repository.dart';

class HttpTutorialService {
  HttpTutorialService({required AuthRepository authRepository, Dio? dio})
    : _authRepository = authRepository,
      _dio = dio ?? Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));

  final AuthRepository _authRepository;
  final Dio _dio;

  static const _stepKey = 'tutorialStep';
  static const _startedKey = 'tutorialStarted';

  Options _authOptions(String token, String sessionId) => Options(
    headers: {'Authorization': 'Bearer $token', 'x-session-id': sessionId},
  );

  Future<({int step, bool started})> fetchProgress() async {
    final creds = _authRepository.getSocketAuthCredentials();
    return creds.when(
      none: () => (step: 0, started: true),
      some: (c) async {
        try {
          final response = await _dio.get<Map<String, dynamic>>(
            '/auth/profile',
            options: _authOptions(c.token, c.sessionId),
          );
          final prefs =
              response.data?['preferences'] as Map<String, dynamic>? ?? {};
          return (
            step: (prefs[_stepKey] as num?)?.toInt() ?? 0,
            started: (prefs[_startedKey] as bool?) ?? false,
          );
        } on Object catch (_) {
          return (step: 0, started: true);
        }
      },
    );
  }

  Future<void> saveProgress({required int step}) async {
    final creds = _authRepository.getSocketAuthCredentials();
    await creds.when(
      none: () {},
      some: (c) async {
        try {
          await _dio.patch<void>(
            '/auth/profile',
            data: {
              'preferences': {_stepKey: step, _startedKey: true},
            },
            options: _authOptions(c.token, c.sessionId),
          );
        } on Object catch (_) {}
      },
    );
  }
}
