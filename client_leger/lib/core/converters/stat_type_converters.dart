import 'package:json_annotation/json_annotation.dart';

import '../../features/game_session/core/enums/stat_type.dart';

class StatTypeConverter implements JsonConverter<StatType, String> {
  const StatTypeConverter();

  @override
  StatType fromJson(String json) {
    final lower = json.toLowerCase();
    for (final e in StatType.values) {
      if (e.name == lower) return e;
    }
    return StatType.values.first;
  }

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
      if (obj is Map) {
        final m = Map<String, dynamic>.from(obj);
        final v = m['value'];
        result[type] = v is int ? v : (v is num ? v.toInt() : 0);
      }
    }
    return result;
  }

  @override
  Map<String, dynamic> toJson(Map<StatType, int> object) => {
    for (final e in object.entries) e.key.name: {'value': e.value},
  };
}
