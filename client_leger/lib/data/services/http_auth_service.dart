import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../core/config/env_config.dart';
import '../../core/constants/http_status.dart';
import '../../core/exceptions/auth_exception.dart';
import '../../domain/interfaces/auth_service.dart';
import '../models/user_dto.dart';
import 'log_service.dart';

class HttpAuthService implements AuthService {
  final Dio _dio;

  HttpAuthService({Dio? dio})
    : _dio = dio ?? Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));

  @override
  TaskEither<AuthException, UserDto> signIn({
    required String identifier,
    required String password,
  }) => TaskEither.tryCatch(() async {
    final response = await _dio.post(
      '/auth/login',
      data: {'identifier': identifier, 'password': password},
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return UserDto.fromJson(data);
    }
    throw const ServerException(
      devMessage: 'Unexpected response format from server',
    );
  }, _onError);

  @override
  TaskEither<AuthException, UserDto> signUp({
    required String username,
    required String email,
    required String password,
  }) => TaskEither.tryCatch(() async {
    LogService.d(
      'Trying to sign up with URL: ${_dio.options.baseUrl}/auth/register',
    );
    LogService.d(
      'Data: ${{'username': username, 'email': email, 'password': password}}',
    );

    final response = await _dio.post(
      '/auth/register',
      data: {'username': username, 'email': email, 'password': password},
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return UserDto.fromJson(data);
    }
    throw const ServerException(
      devMessage: 'Unexpected response format from server',
    );
  }, _onError);

  @override
  TaskEither<AuthException, UserDto> getCurrentUser() =>
      TaskEither.tryCatch(() async {
        final response = await _dio.get('/auth/profile');
        final data = response.data;
        if (data is Map<String, dynamic>) {
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
    final response = await _dio.patch('/auth/profile', data: updates);
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return UserDto.fromJson(data);
    }
    throw const ServerException(
      devMessage: 'Unexpected response format from server',
    );
  }, _onError);

  @override
  TaskEither<AuthException, Unit> signOut() => TaskEither.tryCatch(() async {
    await _dio.post('/auth/logout');
    return unit;
  }, _onError);

  @override
  TaskEither<AuthException, Unit> deleteAccount() =>
      TaskEither.tryCatch(() async {
        await _dio.delete('/auth/account');
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
