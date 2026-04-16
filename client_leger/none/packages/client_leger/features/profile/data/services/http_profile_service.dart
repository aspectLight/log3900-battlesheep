import 'package:dio/dio.dart';

import '../../../../core/config/env_config.dart';
import '../../../../core/helpers/functional_programming.dart';
import '../../../../core/constants/http_status.dart';
import '../../../authentication/data/models/dto/auth_error_response_dto.dart';
import '../../../authentication/core/interfaces/auth_repository.dart';
import '../../../authentication/domain/models/socket_auth_credentials.dart';
import '../../core/exceptions/profile_failure.dart';
import '../../core/constants/profile_api_endpoints.dart';
import '../models/dto/profile_dto.dart';
import '../models/dto/profile_statistics_dto.dart';

class HttpProfileService {
  final AuthRepository _authRepository;
  final Dio _dio;

  HttpProfileService({required AuthRepository authRepository, Dio? dio})
    : _authRepository = authRepository,
      _dio = dio ?? Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));

  Options _authOptions(String token, String sessionId) {
    return Options(
      headers: {'Authorization': 'Bearer $token', 'x-session-id': sessionId},
    );
  }

  Future<ProfileDto> fetchProfile() {
    final creds = _authRepository.getSocketAuthCredentials();
    return creds.when(
      none: () => Future.error(const UnauthorizedProfileFailure()),
      some: (SocketAuthCredentialsModel c) async {
        try {
          final response = await _dio.get<Map<String, dynamic>>(
            ProfileApiEndpoints.profile,
            options: _authOptions(c.token, c.sessionId),
          );
          final data = response.data;
          if (data == null) {
            throw ServerProfileFailure(
              statusCode: response.statusCode,
              devMessage: 'Empty profile response',
            );
          }
          return ProfileDto.fromJson(data);
        } on DioException catch (e) {
          throw _mapDioToFailure(e);
        }
      },
    );
  }

  Future<ProfileStatisticsDto> fetchProfileStatistics() {
    final creds = _authRepository.getSocketAuthCredentials();
    return creds.when(
      none: () => Future.error(const UnauthorizedProfileFailure()),
      some: (SocketAuthCredentialsModel c) async {
        try {
          final response = await _dio.get<Map<String, dynamic>>(
            ProfileApiEndpoints.profileStatistics,
            options: _authOptions(c.token, c.sessionId),
          );
          final data = response.data;
          if (data == null) {
            throw ServerProfileFailure(
              statusCode: response.statusCode,
              devMessage: 'Empty statistics response',
            );
          }
          return ProfileStatisticsDto.fromJson(data);
        } on DioException catch (e) {
          throw _mapDioToFailure(e);
        }
      },
    );
  }

  Future<ProfileDto> updateProfile(ProfileUpdateRequestDto request) {
    final creds = _authRepository.getSocketAuthCredentials();
    return creds.when(
      none: () => Future.error(const UnauthorizedProfileFailure()),
      some: (SocketAuthCredentialsModel c) async {
        try {
          final response = await _dio.patch<Map<String, dynamic>>(
            ProfileApiEndpoints.profile,
            data: request.toJson(),
            options: _authOptions(c.token, c.sessionId),
          );
          final data = response.data;
          if (data == null) {
            throw ServerProfileFailure(
              statusCode: response.statusCode,
              devMessage: 'Empty update profile response',
            );
          }
          final user = data['user'];
          if (user is Map<String, dynamic>) {
            return ProfileDto.fromJson(user);
          }
          return ProfileDto.fromJson(data);
        } on DioException catch (e) {
          throw _mapDioToFailure(e);
        }
      },
    );
  }

  Future<ProfileDto> uploadAvatar(String filePath) {
    final creds = _authRepository.getSocketAuthCredentials();
    return creds.when(
      none: () => Future.error(const UnauthorizedProfileFailure()),
      some: (SocketAuthCredentialsModel c) async {
        try {
          final formData = FormData.fromMap({
            'file': await MultipartFile.fromFile(filePath),
          });
          final response = await _dio.post<Map<String, dynamic>>(
            ProfileApiEndpoints.uploadAvatar,
            data: formData,
            options: _authOptions(c.token, c.sessionId),
          );
          final data = response.data;
          if (data == null) {
            throw ServerProfileFailure(
              statusCode: response.statusCode,
              devMessage: 'Empty upload avatar response',
            );
          }
          final user = data['user'];
          if (user is Map<String, dynamic>) {
            return ProfileDto.fromJson(user);
          }
          return ProfileDto.fromJson(data);
        } on DioException catch (e) {
          throw _mapDioToFailure(e);
        }
      },
    );
  }

  Future<void> deleteAccount() {
    final creds = _authRepository.getSocketAuthCredentials();
    return creds.when(
      none: () => Future.error(const UnauthorizedProfileFailure()),
      some: (SocketAuthCredentialsModel c) async {
        try {
          await _dio.delete<void>(
            ProfileApiEndpoints.deleteAccount,
            options: _authOptions(c.token, c.sessionId),
          );
        } on DioException catch (e) {
          throw _mapDioToFailure(e);
        }
      },
    );
  }

  ProfileFailure _mapDioToFailure(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return const NetworkProfileFailure();
    }

    final response = error.response;
    if (response == null) {
      return const NetworkProfileFailure();
    }

    final data = response.data;
    AuthErrorResponseDto? errorDto;
    if (data is Map<String, dynamic>) {
      try {
        errorDto = AuthErrorResponseDto.fromJson(data);
      } on Object {
        errorDto = null;
      }
    }

    final code = response.statusCode;
    if (code == HttpStatus.badRequest) {
      final message = (errorDto?.errorMessage ?? '').toLowerCase();
      if (message.contains('jpg') ||
          message.contains('jpeg') ||
          message.contains('png')) {
        return const AvatarInvalidFileTypeProfileFailure();
      }
      return const BadRequestProfileFailure();
    }

    return switch (code) {
      HttpStatus.unauthorized => const UnauthorizedProfileFailure(),
      HttpStatus.forbidden => const ForbiddenProfileFailure(),
      HttpStatus.notFound => const NotFoundProfileFailure(),
      HttpStatus.conflict when errorDto?.isUsernameConflict ?? false =>
        const UsernameAlreadyInUseProfileFailure(),
      HttpStatus.conflict => const EmailAlreadyInUseProfileFailure(),
      HttpStatus.payloadTooLarge => const AvatarFileTooLargeProfileFailure(),
      final int? c when c != null && c >= 500 => ServerProfileFailure(
        statusCode: c,
        devMessage: 'Server error: $c',
      ),
      final int? c => ServerProfileFailure(
        statusCode: c,
        devMessage: c != null ? 'HTTP error: $c' : 'HTTP error',
      ),
    };
  }
}
