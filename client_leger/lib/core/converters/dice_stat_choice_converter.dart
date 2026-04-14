import 'package:json_annotation/json_annotation.dart';

import '../enums/dice_stat_choice.dart';

class DiceStatChoiceConverter implements JsonConverter<DiceStatChoice, String> {
  const DiceStatChoiceConverter();

  @override
  DiceStatChoice fromJson(String json) => DiceStatChoice.values.byName(json);

  @override
  String toJson(DiceStatChoice object) => object.name;
}
