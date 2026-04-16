import 'package:json_annotation/json_annotation.dart';

import '../../features/game_session/core/enums/board_character.dart';

class AvatarToCharacterTypeConverter
    implements JsonConverter<BoardCharacterType, Map<String, dynamic>> {
  const AvatarToCharacterTypeConverter();

  @override
  BoardCharacterType fromJson(Map<String, dynamic> json) {
    final raw = json['name'];
    final name = raw is String ? raw : raw?.toString();
    if (name == null || name.isEmpty) {
      return BoardCharacterType.values.first;
    }
    final lower = name.toLowerCase();
    for (final e in BoardCharacterType.values) {
      if (e.name == lower) return e;
    }
    return BoardCharacterType.values.first;
  }

  @override
  Map<String, dynamic> toJson(BoardCharacterType object) => <String, dynamic>{
    'name': object.name,
  };
}

class BoardCharacterColorConverter
    implements JsonConverter<BoardCharacterColor, String> {
  const BoardCharacterColorConverter();

  @override
  BoardCharacterColor fromJson(String json) {
    final lower = json.toLowerCase();
    for (final e in BoardCharacterColor.values) {
      if (e.name == lower) return e;
    }
    return BoardCharacterColor.values.first;
  }

  @override
  String toJson(BoardCharacterColor object) => object.name;
}
