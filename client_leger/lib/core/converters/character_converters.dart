import 'package:json_annotation/json_annotation.dart';

import '../enums/character.dart';

class ChosenAvatarCharacterConverter
    implements JsonConverter<Character, String> {
  const ChosenAvatarCharacterConverter();

  @override
  Character fromJson(String json) => Character.fromAvatarName(json);

  @override
  String toJson(Character object) => object.id;
}

class AvatarObjectCharacterConverter
    implements JsonConverter<Character, Map<String, dynamic>> {
  const AvatarObjectCharacterConverter();

  @override
  Character fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String?;
    if (name != null && name.isNotEmpty) {
      return Character.fromAvatarName(name);
    }
    return Character.dmitry;
  }

  @override
  Map<String, dynamic> toJson(Character object) => {'name': object.id};
}
