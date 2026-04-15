import 'package:json_annotation/json_annotation.dart';

import '../../features/game_session/core/enums/board_character.dart';

class AvatarToCharacterTypeConverter
    implements JsonConverter<BoardCharacterType, Map<String, dynamic>> {
  const AvatarToCharacterTypeConverter();

  @override
  BoardCharacterType fromJson(Map<String, dynamic> json) => BoardCharacterType
      .values
      .firstWhere((e) => e.name == json['name'] as String);

  @override
  Map<String, dynamic> toJson(BoardCharacterType object) => <String, dynamic>{
    'name': object.name,
  };
}

class BoardCharacterColorConverter
    implements JsonConverter<BoardCharacterColor, String> {
  const BoardCharacterColorConverter();

  @override
  BoardCharacterColor fromJson(String json) =>
      BoardCharacterColor.values.firstWhere((e) => e.name == json);

  @override
  String toJson(BoardCharacterColor object) => object.name;
}
