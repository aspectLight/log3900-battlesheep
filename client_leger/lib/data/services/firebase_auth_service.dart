import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../core/config/env_config.dart';
import '../../core/exceptions/auth_exception.dart';
import '../../domain/interfaces/services/firebase_auth_service.dart';
import '../models/firebase_auth_response.dart';
import 'log_service.dart';

class FirebaseAuthServiceImpl implements FirebaseAuthService {
  static const String _baseUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts';

  final Dio _dio;
  final String _apiKey;

  FirebaseAuthServiceImpl({Dio? dio, String? apiKey})
    : _dio = dio ?? Dio(),
      _apiKey = apiKey ?? EnvConfig.firebaseApiKey {
    if (_apiKey.isEmpty) {
      throw const UnknownAuthException('Firebase API Key is missing in .env');
    }
  }

  @override
  TaskEither<AuthException, FirebaseAuthResponse> signInWithEmailPassword({
    required String email,
    required String password,
  }) {
    return TaskEither.tryCatch(
      () async {
        final response = await _dio.post<Map<String, dynamic>>(
          '$_baseUrl:signInWithPassword',
          queryParameters: {'key': _apiKey},
          data: {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        );

        final data = response.data;
        if (data == null) {
          throw const ServerException(devMessage: 'Firebase response is null');
        }

        return FirebaseAuthResponse.fromJson(data);
      },
      (error, stackTrace) {
        if (error is DioException) {
          return _handleFirebaseError(error);
        }
        if (error is AuthException) {
          return error;
        }
        return UnknownAuthException(error.toString());
      },
    );
  }

  AuthException _handleFirebaseError(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final errorInfo = data['error'];
      if (errorInfo is Map<String, dynamic>) {
        final message = errorInfo['message'] as String?;
        LogService.e('Firebase Auth Error: $message');

        if (message == 'EMAIL_NOT_FOUND' ||
            message == 'INVALID_PASSWORD' ||
            message == 'INVALID_LOGIN_CREDENTIALS') {
          return const InvalidCredentialsException();
        }
        if (message == 'INVALID_EMAIL') {
          return const InvalidCredentialsException();
        }
      }
    }
    LogService.e('Firebase Auth Error: ${error.response?.data}');
    return const InvalidCredentialsException();
  }
}
