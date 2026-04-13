class ProfileModel {
  final String id;
  final String username;
  final String email;
  final String avatarId;
  final String theme;
  final String language;

  const ProfileModel({
    required this.id,
    required this.username,
    required this.email,
    required this.avatarId,
    this.theme = 'default',
    this.language = 'fr',
  });
}

