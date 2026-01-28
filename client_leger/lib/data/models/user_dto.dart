import '../../domain/entities/user_entity.dart';

class UserDto {
  final String id;
  final String email;
  final String username;
  final String avatarId;

  UserDto({
    required this.id,
    required this.email,
    required this.username,
    required this.avatarId,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    final userData = json.containsKey('user')
        ? json['user'] as Map<String, dynamic>
        : json;

    return UserDto(
      id: (userData['id'] ?? userData['_id']) as String,
      email: userData['email'] as String,
      username: userData['username'] as String,
      avatarId: userData['avatarId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'avatarId': avatarId,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      uid: id,
      email: email,
      username: username,
      avatarId: avatarId,
    );
  }
}
