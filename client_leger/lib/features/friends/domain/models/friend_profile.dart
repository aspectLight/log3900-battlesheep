class FriendProfile {
  const FriendProfile({
    required this.username,
    required this.avatarId,
    required this.isOnline,
    this.avatarUrl,
  });

  final String username;
  final String avatarId;
  final String? avatarUrl;
  final bool isOnline;

  FriendProfile copyWith({bool? isOnline}) => FriendProfile(
    username: username,
    avatarId: avatarId,
    avatarUrl: avatarUrl,
    isOnline: isOnline ?? this.isOnline,
  );

  factory FriendProfile.fromJson(Map<String, dynamic> json) => FriendProfile(
    username: json['username'] as String,
    avatarId: json['avatarId'] as String? ?? '',
    avatarUrl: json['avatarUrl'] as String?,
    isOnline: json['isOnline'] as bool? ?? false,
  );
}
