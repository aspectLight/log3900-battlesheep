import 'package:json_annotation/json_annotation.dart';

import '../../features/game_session/core/enums/stat_type.dart';

class StatTypeConverter implements JsonConverter<StatType, String> {
  const StatTypeConverter();

  @override
  StatType fromJson(String json) =>
      StatType.values.firstWhere((e) => e.name == json);

  @override
  String toJson(StatType object) => object.name;
}

class StatTypeMapConverter
    implements JsonConverter<Map<StatType, int>, Map<String, dynamic>> {
  const StatTypeMapConverter();

  @override
  Map<StatType, int> fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) return {};
    final result = <StatType, int>{};
    for (final type in StatType.values) {
      final obj = json[type.name];
      if (obj is Map<String, dynamic>) {
        result[type] = obj['value'] as int;
      }
    }
    return result;
  }

  @override
  Map<String, dynamic> toJson(Map<StatType, int> object) =>
      {for (final e in object.entries) e.key.name: {'value': e.value}};
}
