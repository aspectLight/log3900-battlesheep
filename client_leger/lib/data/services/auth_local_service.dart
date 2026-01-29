import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/interfaces/auth_local_service.dart';

import '../models/user_dto.dart';

class AuthLocalServiceImpl implements AuthLocalService {
  final FlutterSecureStorage _storage;
  static const _userKey = 'cached_user';
  static const _tokenKey = 'auth_token';
  static const _sessionIdKey = 'session_id';

  AuthLocalServiceImpl({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<void> saveUser(UserDto user) async {
    final jsonString = jsonEncode(user.toJson());
    await _storage.write(key: _userKey, value: jsonString);
  }

  @override
  Future<UserDto?> getUser() async {
    final jsonString = await _storage.read(key: _userKey);
    if (jsonString == null) return null;
    try {
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserDto.fromJson(jsonMap);
    } on Object catch (_) {
      return null;
    }
  }

  @override
  Future<void> deleteUser() async {
    await _storage.delete(key: _userKey);
  }

  @override
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  @override
  Future<String?> getToken() {
    return _storage.read(key: _tokenKey);
  }

  @override
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  @override
  Future<void> saveSessionId(String sessionId) async {
    await _storage.write(key: _sessionIdKey, value: sessionId);
  }

  @override
  Future<String?> getSessionId() {
    return _storage.read(key: _sessionIdKey);
  }

  @override
  Future<void> deleteSessionId() async {
    await _storage.delete(key: _sessionIdKey);
  }

  @override
  Future<void> clearAll() async {
    await Future.wait([deleteUser(), deleteToken(), deleteSessionId()]);
  }
}
