import '../../data/models/user_dto.dart';

abstract interface class AuthLocalService {
  Future<void> saveUser(UserDto user);
  Future<UserDto?> getUser();
  Future<void> deleteUser();

  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();

  Future<void> saveSessionId(String sessionId);
  Future<String?> getSessionId();
  Future<void> deleteSessionId();

  Future<void> clearAll();
}
