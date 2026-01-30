import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../core/config/env_config.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/constants/http_status.dart';
import '../../core/exceptions/auth_exception.dart';
import '../../domain/interfaces/services/auth_local_service.dart';
import '../../domain/interfaces/services/auth_service.dart';
import '../models/user_dto.dart';
import 'log_service.dart';

class HttpAuthService implements AuthService {
  final Dio _dio;
  final AuthLocalService _localService;

  HttpAuthService({required AuthLocalService localService, Dio? dio})
    : _localService = localService,
      _dio = dio ?? Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));

  Future<Options> _getAuthOptions() async {
    final tokenRes = await _localService.getToken().run();
    final token = tokenRes.getOrElse((_) => none()).toNullable();

    final sessionIdRes = await _localService.getSessionId().run();
    final sessionId = sessionIdRes.getOrElse((_) => none()).toNullable();

    final headers = <String, dynamic>{};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    if (sessionId != null) {
      headers['x-session-id'] = sessionId;
    }
    return Options(headers: headers);
  }

  Future<bool> _hasStoredCredentials() async {
    final tokenRes = await _localService.getToken().run();
    final token = tokenRes.getOrElse((_) => none()).toNullable();

    final sessionIdRes = await _localService.getSessionId().run();
    final sessionId = sessionIdRes.getOrElse((_) => none()).toNullable();

    return token != null && sessionId != null;
  }

  @override
  @override
  TaskEither<AuthException, String> getEmailByUsername(String username) =>
      TaskEither.tryCatch(() async {
        LogService.d('Getting email for username: $username');

        final response = await _dio.post<Map<String, dynamic>>(
          ApiEndpoints.getEmailByUsername,
          data: {'username': username},
        );

        final data = response.data;
        if (data == null || data['email'] == null) {
          throw const UserNotFoundException();
        }

        final email = data['email'] as String;
        LogService.d('Retrieved email for $username: $email');
        return email;
      }, _onError);

  @override
  TaskEither<AuthException, UserDto> signInWithToken({
    required String firebaseToken,
  }) => TaskEither.tryCatch(() async {
    LogService.d('Signing in with token');

    // Send token to server
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: {'token': firebaseToken},
    );

    final data = response.data;
    if (data == null) {
      throw const ServerException(devMessage: 'Server login response is null');
    }

    final sessionId = data['sessionId'] as String?;
    if (sessionId == null) {
      throw const ServerException(devMessage: 'Session ID not in response');
    }

    final saveTokenRes = await _localService.saveToken(firebaseToken).run();
    if (saveTokenRes.isLeft()) throw saveTokenRes.getLeft().toNullable()!;

    final saveSessionRes = await _localService.saveSessionId(sessionId).run();
    if (saveSessionRes.isLeft()) throw saveSessionRes.getLeft().toNullable()!;

    if (data['user'] != null) {
      final userDto = UserDto.fromJson(data['user']);
      final saveUserRes = await _localService.saveUser(userDto).run();
      if (saveUserRes.isLeft()) throw saveUserRes.getLeft().toNullable()!;

      LogService.d('Login successful: ${userDto.username}');
      return userDto;
    }

    throw const ServerException(devMessage: 'User data not in response');
  }, _onError);

  @override
  TaskEither<AuthException, UserDto> signUp({
    required String username,
    required String email,
    required String password,
  }) => TaskEither.tryCatch(() async {
    final url = '${_dio.options.baseUrl}${ApiEndpoints.register}';
    LogService.d('Trying to sign up with URL: $url');

    final requestData = {
      'username': username,
      'email': email,
      'password': password,
      'avatarId': 'default',
    };
    LogService.d('Data: $requestData');

    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.register,
      data: requestData,
    );

    if (response.data == null) {
      throw const ServerException(devMessage: 'Registration response is null');
    }

    LogService.d('Registration successful');

    return UserDto(
      id: '',
      username: username,
      email: email,
      avatarId: 'default',
    );
  }, _onError);

  @override
  TaskEither<AuthException, UserDto> getCurrentUser() =>
      TaskEither.tryCatch(() async {
        if (!await _hasStoredCredentials()) {
          throw const InvalidCredentialsException();
        }

        final options = await _getAuthOptions();
        final response = await _dio.get<Map<String, dynamic>>(
          ApiEndpoints.userProfile,
          options: options,
        );
        final data = response.data;
        if (data != null) {
          return UserDto.fromJson(data);
        }
        throw const ServerException(
          devMessage: 'Unexpected response format from server',
        );
      }, _onError);

  @override
  TaskEither<AuthException, UserDto> updateProfile(
    Map<String, dynamic> updates,
  ) => TaskEither.tryCatch(() async {
    final options = await _getAuthOptions();
    final response = await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.userProfile,
      data: updates,
      options: options,
    );
    final data = response.data;
    if (data != null) {
      return UserDto.fromJson(data);
    }
    throw const ServerException(
      devMessage: 'Unexpected response format from server',
    );
  }, _onError);

  @override
  TaskEither<AuthException, Unit> signOut() => TaskEither.tryCatch(() async {
    final options = await _getAuthOptions();
    await _dio.post(ApiEndpoints.logout, options: options);
    final result = await _localService.clearAll().run();
    if (result.isLeft()) throw result.getLeft().toNullable()!;
    return unit;
  }, _onError);

  @override
  TaskEither<AuthException, Unit> deleteAccount() =>
      TaskEither.tryCatch(() async {
        final options = await _getAuthOptions();
        await _dio.delete(ApiEndpoints.deleteAccount, options: options);
        final result = await _localService.clearAll().run();
        if (result.isLeft()) throw result.getLeft().toNullable()!;
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
    if (response != null) {
      LogService.e('Received Error Response: ${response.statusCode}');
      LogService.e('Response Data: ${response.data}');

      final data = response.data;
      String? errorMessage;

      if (data is Map<String, dynamic>) {
        final Object? message = data['message'];
        if (message is String) {
          errorMessage = message;
        } else if (message is List) {
          errorMessage = message.join(', ');
        }
      }

      final statusCode = response.statusCode;
      if (statusCode == HttpStatus.unauthorized) {
        return const InvalidCredentialsException();
      }
      if (statusCode == HttpStatus.notFound) {
        return const UserNotFoundException();
      }
      if (statusCode == HttpStatus.conflict) {
        return const EmailAlreadyInUseException();
      }

      return ServerException(
        statusCode: statusCode,
        devMessage: errorMessage ?? 'Server error: $statusCode',
      );
    }
    return const NetworkException();
  }
}
