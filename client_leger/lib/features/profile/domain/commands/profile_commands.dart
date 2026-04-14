class UpdateProfileCommand {
  final String? username;
  final String? email;
  final String? avatarId;
  final String? theme;
  final String? language;
  final Map<String, dynamic>? preferences;

  const UpdateProfileCommand({
    this.username,
    this.email,
    this.avatarId,
    this.theme,
    this.language,
    this.preferences,
  });
}
