import '../enums/avatar.dart';

/// Miniatures tête / buste (comme `avatar` dans le client Angular), pas les sprites full body.
class AvatarAssets {
  static const String path = 'assets/images/avatars';

  /// In-game / shop preset bust (`dmitry`, …); `null` if [id] does not match.
  static String? tryMiniaturePathForProfileId(String id) {
    for (final a in Avatar.values) {
      if (a.id == id) return avatarPath(a);
    }
    return null;
  }

  static String avatarPath(Avatar avatar) => switch (avatar) {
    Avatar.dmitry => '$path/dmitryAvatar.png',
    Avatar.georgie => '$path/georgieAvatar.png',
    Avatar.gorkina => '$path/gorkinaAvatar.png',
    Avatar.irina => '$path/irinaAvatar.png',
    Avatar.ivanov => '$path/ivanovAvatar.png',
    Avatar.ladeve => '$path/ladeveAvatar.png',
    Avatar.misha => '$path/mishaAvatar.png',
    Avatar.petrov => '$path/petrovAvatar.png',
    Avatar.sergei => '$path/sergeiAvatar.png',
    Avatar.sokolov => '$path/sokolovAvatar.png',
    Avatar.viktor => '$path/viktorAvatar.png',
    Avatar.volkov => '$path/volkovAvatar.png',
  };
}
