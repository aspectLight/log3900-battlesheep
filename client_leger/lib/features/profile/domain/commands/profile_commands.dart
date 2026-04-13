class UpdateProfileCommand {
  final String username;
  final String email;
  final String avatarId;

  const UpdateProfileCommand({
    required this.username,
    required this.email,
    required this.avatarId,
  });
}
