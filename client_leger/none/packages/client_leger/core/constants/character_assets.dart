import '../enums/character.dart';
import '../../features/game_session/core/enums/board_character.dart';

class CharacterAssets {
  static const String avatarsPath = 'assets/images/avatars';
  static const String charactersPath = 'assets/images/characters';

  static const String characterShadow = '$charactersPath/shadow.png';

  static String characterAvatarPath(Character character) => switch (character) {
    Character.dmitry => '$avatarsPath/dmitryAvatar.png',
    Character.georgie => '$avatarsPath/georgieAvatar.png',
    Character.gorkina => '$avatarsPath/gorkinaAvatar.png',
    Character.irina => '$avatarsPath/irinaAvatar.png',
    Character.ivanov => '$avatarsPath/ivanovAvatar.png',
    Character.ladeve => '$avatarsPath/ladeveAvatar.png',
    Character.misha => '$avatarsPath/mishaAvatar.png',
    Character.petrov => '$avatarsPath/petrovAvatar.png',
    Character.sergei => '$avatarsPath/sergeiAvatar.png',
    Character.sokolov => '$avatarsPath/sokolovAvatar.png',
    Character.viktor => '$avatarsPath/viktorAvatar.png',
    Character.volkov => '$avatarsPath/volkovAvatar.png',
  };

  static String characterAvatarFullPath(Character character) =>
      switch (character) {
        Character.dmitry => '$avatarsPath/dmitryFull.png',
        Character.georgie => '$avatarsPath/georgieFull.png',
        Character.gorkina => '$avatarsPath/gorkinaFull.png',
        Character.irina => '$avatarsPath/irinaFull.png',
        Character.ivanov => '$avatarsPath/ivanovFull.png',
        Character.ladeve => '$avatarsPath/ladeveFull.png',
        Character.misha => '$avatarsPath/mishaFull.png',
        Character.petrov => '$avatarsPath/petrovFull.png',
        Character.sergei => '$avatarsPath/sergeiFull.png',
        Character.sokolov => '$avatarsPath/sokolovFull.png',
        Character.viktor => '$avatarsPath/viktorFull.png',
        Character.volkov => '$avatarsPath/volkovFull.png',
      };

  static String gameBoardCharacter(
    BoardCharacterColor color,
    BoardCharacterState state,
    BoardCharacterOrientation orientation,
  ) {
    return '$charactersPath/${color.name}/${state.name}_${orientation.name}.gif';
  }
}
