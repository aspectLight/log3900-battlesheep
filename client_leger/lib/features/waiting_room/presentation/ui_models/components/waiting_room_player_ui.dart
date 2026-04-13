class WaitingRoomPlayerUi {
  final String id;
  final String name;
  final String avatarFullPath;
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
    required this.isVirtual,
    required this.health,
    required this.speed,
    required this.attack,
    required this.defense,
    this.activeBanner,
  });
}
