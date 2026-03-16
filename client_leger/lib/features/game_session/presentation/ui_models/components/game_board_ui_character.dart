import '../../../../../core/enums/character.dart';
import '../../../../../core/constants/character_assets.dart';
import '../../../core/enums/board_character.dart';

class GameBoardUiCharacter {
  final String id;
  final String name;
  final BoardCharacterType characterType;
  final BoardCharacterColor color;
  final BoardCharacterOrientation orientation;
  final BoardCharacterState state;

  const GameBoardUiCharacter({
    required this.id,
    required this.name,
    required this.characterType,
    required this.color,
    required this.orientation,
    required this.state,
  });

  String get imagePath =>
      CharacterAssets.gameBoardCharacter(color, state, orientation);

  String get avatarFullPath =>
      CharacterAssets.characterAvatarFullPath(
        Character.values.byName(characterType.name),
      );
}
