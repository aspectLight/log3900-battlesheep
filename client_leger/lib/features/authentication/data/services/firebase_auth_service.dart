import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/services/log_service.dart';
import '../../core/constants/firebase_auth_error_codes.dart';
import '../../core/exceptions/auth_exception.dart';
import '../../domain/results/firebase_sign_in_result.dart';
import '../models/dto/firebase_auth_error_response_dto.dart';
import '../models/dto/firebase_auth_response.dart';
import '../models/dto/firebase_sign_in_request_dto.dart';

class FirebaseAuthService {
  final Dio _dio;
  final String _apiKey;
  final String _baseUrl;

  FirebaseAuthService({
    required Dio dio,
    required String apiKey,
    required String baseUrl,
  }) : _dio = dio,
       _apiKey = apiKey,
       _baseUrl = baseUrl {
    if (_apiKey.isEmpty) {
      throw const UnknownAuthException('Firebase API Key is missing in .env');
    }
  }

  TaskEither<AuthException, FirebaseSignInResult> signInWithEmailPassword({
    required String email,
    required String password,
  }) {
    return TaskEither.tryCatch(
      () async {
        final response = await _dio.post<Map<String, dynamic>>(
          '$_baseUrl:signInWithPassword',
          queryParameters: {'key': _apiKey},
          data: FirebaseSignInRequestDto(
            email: email,
            password: password,
          ).toJson(),
        );

        final data = response.data;
        if (data == null) {
          throw const ServerException(devMessage: 'Firebase response is null');
        }

        final authResponse = FirebaseAuthResponse.fromJson(data);
        return FirebaseSignInResult(idToken: authResponse.idToken);
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
    final errorMessage = data is Map<String, dynamic>
        ? FirebaseAuthErrorResponseDto.fromJson(data).errorMessage
        : null;

    LogService.e('Firebase Auth Error: $errorMessage');

    if (errorMessage == FirebaseAuthErrorCodes.emailNotFound ||
        errorMessage == FirebaseAuthErrorCodes.invalidPassword ||
        errorMessage == FirebaseAuthErrorCodes.invalidLoginCredentials ||
        errorMessage == FirebaseAuthErrorCodes.invalidEmail) {
      return const InvalidCredentialsException();
    }

    return const InvalidCredentialsException();
  }
}
