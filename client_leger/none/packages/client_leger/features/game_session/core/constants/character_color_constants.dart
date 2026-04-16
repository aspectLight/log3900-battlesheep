import '../enums/board_character.dart';

class CharacterColorConstants {
  static String hex(BoardCharacterColor color) => switch (color) {
    BoardCharacterColor.blue => '0xFF1A1A5C',
    BoardCharacterColor.green => '0xFF2E5E2E',
    BoardCharacterColor.pink => '0xFFFF69B4',
    BoardCharacterColor.purple => '0xFF4B0082',
    BoardCharacterColor.red => '0xFF8B1A1A',
    BoardCharacterColor.yellow => '0xFFB8860B',
  };
}
