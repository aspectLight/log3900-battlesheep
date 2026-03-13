import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/config/env_config.dart';
import '../../../../core/helpers/functional_programming.dart';
import '../../../authentication/core/interfaces/auth_repository.dart';
import '../../../authentication/domain/models/socket_auth_credentials.dart';
import '../../core/constants/profile_api_endpoints.dart';
import '../models/dto/profile_dto.dart';
import '../models/dto/profile_statistics_dto.dart';

class HttpProfileService {
  final AuthRepository _authRepository;
  final Dio _dio;

  HttpProfileService({
    required AuthRepository authRepository,
    Dio? dio,
  })  : _authRepository = authRepository,
        _dio = dio ?? Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));

  Options _authOptions(String token, String sessionId) {
    return Options(
      headers: {
        'Authorization': 'Bearer $token',
        'x-session-id': sessionId,
      },
    );
  }

  Future<Option<ProfileDto>> fetchProfile() {
    final creds = _authRepository.getSocketAuthCredentials();
    return creds.when(
      none: () => Future<Option<ProfileDto>>.value(const None()),
      some: (SocketAuthCredentialsModel c) async {
        final response = await _dio.get<Map<String, dynamic>>(
          ProfileApiEndpoints.profile,
          options: _authOptions(c.token, c.sessionId),
        );
        final data = response.data;
        if (data == null) {
          return const None();
        }
        return Option.of(ProfileDto.fromJson(data));
      },
    );
  }

  Future<Option<ProfileStatisticsDto>> fetchProfileStatistics() {
    final creds = _authRepository.getSocketAuthCredentials();
    return creds.when(
      none: () => Future<Option<ProfileStatisticsDto>>.value(const None()),
      some: (SocketAuthCredentialsModel c) async {
        final response = await _dio.get<Map<String, dynamic>>(
          ProfileApiEndpoints.profileStatistics,
          options: _authOptions(c.token, c.sessionId),
        );
        final data = response.data;
        if (data == null) {
          return const None();
        }
        return Option.of(ProfileStatisticsDto.fromJson(data));
      },
    );
  }

  Future<Option<ProfileDto>> updateProfile(ProfileUpdateRequestDto request) {
    final creds = _authRepository.getSocketAuthCredentials();
    return creds.when(
      none: () => Future<Option<ProfileDto>>.value(const None()),
      some: (SocketAuthCredentialsModel c) async {
        final response = await _dio.patch<Map<String, dynamic>>(
          ProfileApiEndpoints.profile,
          data: request.toJson(),
          options: _authOptions(c.token, c.sessionId),
        );
        final data = response.data;
        if (data == null) {
          return const None();
        }
        return Option.of(ProfileDto.fromJson(data));
      },
    );
  }

  Future<bool> deleteAccount() {
    final creds = _authRepository.getSocketAuthCredentials();
    return creds.when(
      none: () => Future<bool>.value(false),
      some: (SocketAuthCredentialsModel c) async {
        await _dio.delete<void>(
          ProfileApiEndpoints.deleteAccount,
          options: _authOptions(c.token, c.sessionId),
        );
        return true;
      },
    );
  }
}

