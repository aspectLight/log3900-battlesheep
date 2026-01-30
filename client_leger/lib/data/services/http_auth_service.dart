import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../core/config/env_config.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/constants/http_status.dart';
import '../../core/exceptions/auth_exception.dart';
import '../../domain/interfaces/auth_local_service.dart';
import '../../domain/interfaces/auth_service.dart';
import '../models/user_dto.dart';
import 'firebase_auth_service.dart';
import 'log_service.dart';

class HttpAuthService implements AuthService {
  final Dio _dio;
  final AuthLocalService _localService;
  final FirebaseAuthService _firebaseAuth;

  HttpAuthService({
    required AuthLocalService localService,
    FirebaseAuthService? firebaseAuth,
    Dio? dio,
  }) : _localService = localService,
       _firebaseAuth = firebaseAuth ?? FirebaseAuthService(),
       _dio = dio ?? Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));

  Future<void> _addAuthHeaders() async {
    final token = await _localService.getToken();
    final sessionId = await _localService.getSessionId();

    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
    if (sessionId != null) {
      _dio.options.headers['x-session-id'] = sessionId;
    }
  }

  Future<bool> hasStoredCredentials() async {
    final token = await _localService.getToken();
    final sessionId = await _localService.getSessionId();
    return token != null && sessionId != null;
  }

  @override
  TaskEither<AuthException, UserDto> signIn({
    required String username,
    required String password,
  }) => TaskEither.tryCatch(() async {
    LogService.d('Attempting login for username: $username');

    // 1. Get email from username
    final emailResponse = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.getEmailByUsername,
      data: {'username': username},
    );

    final emailData = emailResponse.data;
    if (emailData == null || emailData['email'] == null) {
      throw const UserNotFoundException();
    }
    final email = emailData['email'] as String;

    LogService.d('Retrieved email for $username: $email');

    // 2. Authenticate with Firebase using email
    final firebaseAuth = await _firebaseAuth.signInWithEmailPassword(
      email: email,
      password: password,
    );

    // 3. Send token to server
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: {'token': firebaseAuth.idToken},
    );

    final data = response.data;
    if (data == null) {
      throw const ServerException(devMessage: 'Server login response is null');
    }

    final sessionId = data['sessionId'] as String?;
    if (sessionId == null) {
      throw const ServerException(devMessage: 'Session ID not in response');
    }

    await _localService.saveToken(firebaseAuth.idToken);
    await _localService.saveSessionId(sessionId);

    if (data['user'] != null) {
      final userDto = UserDto.fromJson(data['user']);
      await _localService.saveUser(userDto);
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

    LogService.d('Registration successful, performing auto-login...');
    final loginResult = await signIn(
      username: username,
      password: password,
    ).run();

    return loginResult.fold((error) => throw error, (user) => user);
  }, _onError);

  @override
  TaskEither<AuthException, UserDto> getCurrentUser() =>
      TaskEither.tryCatch(() async {
        if (!await hasStoredCredentials()) {
          throw const InvalidCredentialsException();
        }

        await _addAuthHeaders();
        final response = await _dio.get<Map<String, dynamic>>(
          ApiEndpoints.userProfile,
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
    await _addAuthHeaders();
    final response = await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.userProfile,
      data: updates,
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
    await _addAuthHeaders();
    await _dio.post(ApiEndpoints.logout);
    await _localService.clearAll();
    return unit;
  }, _onError);

  @override
  TaskEither<AuthException, Unit> deleteAccount() =>
      TaskEither.tryCatch(() async {
        await _addAuthHeaders();
        await _dio.delete(ApiEndpoints.deleteAccount);
        await _localService.clearAll();
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
