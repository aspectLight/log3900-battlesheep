import 'package:fpdart/fpdart.dart';

import '../../../../../core/enums/avatar.dart';

class GamePlayerUiCard {
  final String id;
  final String name;
  final Avatar avatar;
  final String color;
  final bool isActiveTurn;
  final bool isHost;
  final bool isDisconnected;
  final bool isVirtual;
  final Option<int> team;
  final bool hasFlag;
  final int fightsWon;

  const GamePlayerUiCard({
    required this.id,
    required this.name,
    required this.avatar,
    required this.color,
    required this.fightsWon,
    this.isActiveTurn = false,
    this.isHost = false,
    this.isDisconnected = false,
    this.isVirtual = false,
    required this.team,
    this.hasFlag = false,
  });
}
