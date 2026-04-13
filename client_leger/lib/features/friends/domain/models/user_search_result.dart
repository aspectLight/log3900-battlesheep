class UserSearchResult {
  const UserSearchResult({
    required this.username,
    required this.avatarId,
    required this.isOnline,
    this.avatarUrl,
  });

  final String username;
  final String avatarId;
  final String? avatarUrl;
  final bool isOnline;

  factory UserSearchResult.fromJson(Map<String, dynamic> json) =>
      UserSearchResult(
        username: json['username'] as String,
        avatarId: json['avatarId'] as String? ?? '',
        avatarUrl: json['avatarUrl'] as String?,
        isOnline: json['isOnline'] as bool? ?? false,
      );
}
