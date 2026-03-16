import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../core/constants/api_endpoints.dart';
import '../../../../core/constants/http_status.dart';
import '../../core/exceptions/auth_exception.dart';
import '../../../../core/services/log_service.dart';

import '../../domain/models/user.dart';
import '../../domain/results/auth_sign_in_result.dart';
import '../models/dto/user_dto.dart';
import '../models/dto/sign_in_request_dto.dart';
import '../models/dto/sign_in_response_dto.dart';
import '../models/dto/sign_up_request_dto.dart';
import '../models/dto/update_profile_request_dto.dart';
import '../models/dto/get_email_by_username_request_dto.dart';
import '../models/dto/get_email_by_username_response_dto.dart';
import '../models/dto/auth_error_response_dto.dart';
import '../models/dto/sign_up_response_dto.dart';
import '../models/dto/auth_headers_dto.dart';
import '../models/extensions/user_dto_extensions.dart';

class HttpAuthService {
  final Dio _dio;

  HttpAuthService({required Dio dio}) : _dio = dio;

  Options _authOptions(String apiToken, String apiSessionId) {
    return Options(
      headers: AuthHeadersDto.create(
        apiToken: apiToken,
        apiSessionId: apiSessionId,
      ).toJson(),
    );
  }

  TaskEither<AuthException, String> getEmailByUsername(String username) =>
      TaskEither.tryCatch(() async {
        LogService.d('Getting email for username: $username');

        final response = await _dio.post<Map<String, dynamic>>(
          AuthApiEndpoints.getEmailByUsername,
          data: GetEmailByUsernameRequestDto(username: username).toJson(),
        );

        final data = response.data;
        if (data == null) {
          throw const UserNotFoundException();
        }

        final dto = GetEmailByUsernameResponseDto.fromJson(data);
        final email = dto.email;
        LogService.d('Retrieved email for $username: $email');
        return email;
      }, _onError);

  TaskEither<AuthException, AuthSignInResult> signInWithToken({
    required String firebaseToken,
  }) => TaskEither.tryCatch(() async {
    LogService.d('Signing in with token');

    final response = await _dio.post<Map<String, dynamic>>(
      AuthApiEndpoints.login,
      data: SignInRequestDto(token: firebaseToken).toJson(),
    );

    final data = response.data;
    if (data == null) {
      throw const ServerException(devMessage: 'Server login response is null');
    }

    final signInResponse = SignInResponseDto.fromJson(data);
    LogService.d('Login successful: ${signInResponse.user.username}');
    return AuthSignInResult(
      user: signInResponse.user.toModel(),
      apiToken: firebaseToken,
      apiSessionId: signInResponse.sessionId,
    );
  }, _onError);

  TaskEither<AuthException, UserModel> signUp({
    required String username,
    required String email,
    required String password,
    required String avatarId,
  }) => TaskEither.tryCatch(() async {
    LogService.d('Trying to sign up');

    final response = await _dio.post<Map<String, dynamic>>(
      AuthApiEndpoints.register,
      data: SignUpRequestDto(
        username: username,
        email: email,
        password: password,
        avatarId: avatarId,
      ).toJson(),
    );

    final Map<String, dynamic>? data = response.data;
    if (data == null) {
      throw const ServerException(devMessage: 'Registration response is null');
    }

    LogService.d('Registration successful');

    final signUpResponse = SignUpResponseDto.fromJson(data);
    return signUpResponse.user.toModel();
  }, _onError);

  TaskEither<AuthException, UserModel> getCurrentUser({
    required String apiToken,
    required String apiSessionId,
  }) => TaskEither.tryCatch(() async {
    final options = _authOptions(apiToken, apiSessionId);
    final response = await _dio.get<Map<String, dynamic>>(
      AuthApiEndpoints.userProfile,
      options: options,
    );
    final data = response.data;
    if (data != null) {
      return UserDto.fromJson(data).toModel();
    }
    throw const ServerException(
      devMessage: 'Unexpected response format from server',
    );
  }, _onError);

  TaskEither<AuthException, UserModel> updateProfile({
    String? username,
    String? email,
    String? avatarId,
    required String apiToken,
    required String apiSessionId,
  }) => TaskEither.tryCatch(() async {
    final options = _authOptions(apiToken, apiSessionId);
    final payload = UpdateProfileRequestDto(
      username: username,
      email: email,
      avatarId: avatarId,
    ).toJson();
    final response = await _dio.patch<Map<String, dynamic>>(
      AuthApiEndpoints.userProfile,
      data: payload,
      options: options,
    );
    final data = response.data;
    if (data != null) {
      return UserDto.fromJson(data).toModel();
    }
    throw const ServerException(
      devMessage: 'Unexpected response format from server',
    );
  }, _onError);

  TaskEither<AuthException, Unit> signOut({
    required String apiToken,
    required String apiSessionId,
  }) => TaskEither.tryCatch(() async {
    final options = _authOptions(apiToken, apiSessionId);
    await _dio.post(AuthApiEndpoints.logout, options: options);
    return unit;
  }, _onError);

  TaskEither<AuthException, Unit> deleteAccount({
    required String apiToken,
    required String apiSessionId,
  }) => TaskEither.tryCatch(() async {
    final options = _authOptions(apiToken, apiSessionId);
    await _dio.delete(AuthApiEndpoints.deleteAccount, options: options);
    return unit;
  }, _onError);

  AuthException _onError(Object error, StackTrace stackTrace) {
    if (error is AuthException) return error;
    if (error is DioException) return _handleDioError(error);
    return UnknownAuthException(error.toString());
  }

  AuthException _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return const NetworkException();
    }

    final response = error.response;
    if (response == null) return const NetworkException();

    final data = response.data;
    final errorDto = data is Map<String, dynamic>
        ? AuthErrorResponseDto.fromJson(data)
        : null;

    return switch (response.statusCode) {
      HttpStatus.unauthorized => const InvalidCredentialsException(),
      HttpStatus.forbidden => const AccountAlreadyConnectedException(),
      HttpStatus.notFound => const UserNotFoundException(),
      HttpStatus.conflict when errorDto?.isUsernameConflict ?? false =>
        const UsernameAlreadyInUseException(),
      HttpStatus.conflict => const EmailAlreadyInUseException(),
      final code => ServerException(
          statusCode: code,
          devMessage: errorDto?.errorMessage ?? 'Server error: $code',
        ),
    };
  }
}
