import '../enums/virtual_player_type.dart';

class LobbyPlayerModel {
  const LobbyPlayerModel({
    required this.id,
    required this.name,
    required this.avatarName,
    required this.isVirtual,
    required this.virtualType,
    required this.health,
    required this.speed,
    required this.attack,
    required this.defense,
  });

  final String id;
  final String name;
  final String avatarName;
  final bool isVirtual;
  final VirtualPlayerType virtualType;
  final int health;
  final int speed;
  final int attack;
  final int defense;
}
