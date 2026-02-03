import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/interfaces/services/auth_local_service.dart';

import '../models/user_dto.dart';

class AuthLocalServiceImpl implements AuthLocalService {
  final FlutterSecureStorage _storage;
  static const _userKey = 'cached_user';
  static const _tokenKey = 'auth_token';
  static const _sessionIdKey = 'session_id';

  AuthLocalServiceImpl({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  @override
  TaskEither<Exception, Unit> saveUser(UserDto user) {
    return TaskEither.tryCatch(() async {
      final jsonString = jsonEncode(user.toJson());
      await _storage.write(key: _userKey, value: jsonString);
      return unit;
    }, (error, stackTrace) => error is Exception ? error : Exception(error));
  }

  @override
  TaskEither<Exception, Option<UserDto>> getUser() {
    return TaskEither.tryCatch(() async {
      final jsonString = await _storage.read(key: _userKey);
      if (jsonString == null) return none();
      try {
        final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
        return some(UserDto.fromJson(jsonMap));
      } on Object catch (_) {
        return none();
      }
    }, (error, stackTrace) => error is Exception ? error : Exception(error));
  }

  @override
  TaskEither<Exception, Unit> deleteUser() {
    return TaskEither.tryCatch(() async {
      await _storage.delete(key: _userKey);
      return unit;
    }, (error, stackTrace) => error is Exception ? error : Exception(error));
  }

  @override
  TaskEither<Exception, Unit> saveToken(String token) {
    return TaskEither.tryCatch(() async {
      await _storage.write(key: _tokenKey, value: token);
      return unit;
    }, (error, stackTrace) => error is Exception ? error : Exception(error));
  }

  @override
  TaskEither<Exception, Option<String>> getToken() {
    return TaskEither.tryCatch(() async {
      final token = await _storage.read(key: _tokenKey);
      return optionOf(token);
    }, (error, stackTrace) => error is Exception ? error : Exception(error));
  }

  @override
  TaskEither<Exception, Unit> deleteToken() {
    return TaskEither.tryCatch(() async {
      await _storage.delete(key: _tokenKey);
      return unit;
    }, (error, stackTrace) => error is Exception ? error : Exception(error));
  }

  @override
  TaskEither<Exception, Unit> saveSessionId(String sessionId) {
    return TaskEither.tryCatch(() async {
      await _storage.write(key: _sessionIdKey, value: sessionId);
      return unit;
    }, (error, stackTrace) => error is Exception ? error : Exception(error));
  }

  @override
  TaskEither<Exception, Option<String>> getSessionId() {
    return TaskEither.tryCatch(() async {
      final sessionId = await _storage.read(key: _sessionIdKey);
      return optionOf(sessionId);
    }, (error, stackTrace) => error is Exception ? error : Exception(error));
  }

  @override
  TaskEither<Exception, Unit> deleteSessionId() {
    return TaskEither.tryCatch(() async {
      await _storage.delete(key: _sessionIdKey);
      return unit;
    }, (error, stackTrace) => error is Exception ? error : Exception(error));
  }

  @override
  TaskEither<Exception, Unit> clearAll() {
    return TaskEither.tryCatch(() async {
      await Future.wait([
        deleteUser().run(),
        deleteToken().run(),
        deleteSessionId().run(),
      ]);
      return unit;
    }, (error, stackTrace) => error is Exception ? error : Exception(error));
  }
}
