import 'package:json_annotation/json_annotation.dart';

import '../enums/dice_stat_choice.dart';

/// Angular sends [health, speed, attack, defense] for dice/bonus stats; only
/// attack/defense map to [DiceStatChoice]. Unknown values become null.
class WaitingRoomDiceStatChoiceConverter
    implements JsonConverter<DiceStatChoice?, Object?> {
  const WaitingRoomDiceStatChoiceConverter();

  @override
  DiceStatChoice? fromJson(Object? json) {
    if (json == null) return null;
    if (json is! String) return null;
    switch (json) {
      case 'attack':
        return DiceStatChoice.attack;
      case 'defense':
        return DiceStatChoice.defense;
      default:
        return null;
    }
  }

  @override
  Object? toJson(DiceStatChoice? object) => object?.name;
}
