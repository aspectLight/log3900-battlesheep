import '../../data/models/user_dto.dart';

abstract interface class AuthLocalService {
  Future<void> saveUser(UserDto user);
  Future<UserDto?> getUser();
  Future<void> deleteUser();
}
