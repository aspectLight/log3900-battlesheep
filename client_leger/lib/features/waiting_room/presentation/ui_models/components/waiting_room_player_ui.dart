class WaitingRoomPlayerUi {
  final String id;
  final String name;
  final String avatarFullPath;
  final String? profileAvatarId;
  final String? profileAvatarUrl;
  final bool isVirtual;
  final int health;
  final int speed;
  final int attack;
  final int defense;
  final String? activeBanner;

  const WaitingRoomPlayerUi({
    required this.id,
    required this.name,
    required this.avatarFullPath,
    this.profileAvatarId,
    this.profileAvatarUrl,
    required this.isVirtual,
    required this.health,
    required this.speed,
    required this.attack,
    required this.defense,
    this.activeBanner,
  });
}
