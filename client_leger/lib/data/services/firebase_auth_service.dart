import 'package:dio/dio.dart';
import '../../core/config/env_config.dart';
import '../../core/exceptions/auth_exception.dart';
import '../models/firebase_auth_response.dart';
import 'log_service.dart';

class FirebaseAuthService {
  static const String _baseUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts';

  final Dio _dio;
  final String _apiKey;

  FirebaseAuthService({Dio? dio, String? apiKey})
    : _dio = dio ?? Dio(),
      _apiKey = apiKey ?? EnvConfig.firebaseApiKey;

  Future<FirebaseAuthResponse> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    _validateApiKey();

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$_baseUrl:signInWithPassword',
        queryParameters: {'key': _apiKey},
        data: {'email': email, 'password': password, 'returnSecureToken': true},
      );

      final data = response.data;
      if (data == null) {
        throw const ServerException(devMessage: 'Firebase response is null');
      }

      return FirebaseAuthResponse.fromJson(data);
    } on DioException catch (e) {
      _handleFirebaseError(e);
    }
  }

  void _validateApiKey() {
    if (_apiKey.isEmpty) {
      throw const UnknownAuthException('Firebase API Key is missing in .env');
    }
  }

  Never _handleFirebaseError(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final errorInfo = data['error'];
      if (errorInfo is Map<String, dynamic>) {
        final message = errorInfo['message'] as String?;
        LogService.e('Firebase Auth Error: $message');

        if (message == 'EMAIL_NOT_FOUND' ||
            message == 'INVALID_PASSWORD' ||
            message == 'INVALID_LOGIN_CREDENTIALS') {
          throw const InvalidCredentialsException();
        }
        if (message == 'INVALID_EMAIL') {
          throw const InvalidCredentialsException();
        }
      }
    }
    LogService.e('Firebase Auth Error: ${error.response?.data}');
    throw const InvalidCredentialsException();
  }
}
