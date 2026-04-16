class ProfileModel {
  final String id;
  final String? firebaseUid;
  final String username;
  final String email;
  final String avatarId;
  final String? avatarUrl;
  final String theme;
  final String language;

  const ProfileModel({
    required this.id,
    this.firebaseUid,
    required this.username,
    required this.email,
    required this.avatarId,
    this.avatarUrl,
    this.theme = 'default',
    this.language = 'fr',
  });
}
