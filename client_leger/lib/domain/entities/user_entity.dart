class UserEntity {
  final String uid;
  final String email;
  final String username;
  final String avatarId;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.username,
    required this.avatarId,
  });

  UserEntity copyWith({
    String? uid,
    String? email,
    String? username,
    String? avatarId,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      avatarId: avatarId ?? this.avatarId,
    );
  }
}
