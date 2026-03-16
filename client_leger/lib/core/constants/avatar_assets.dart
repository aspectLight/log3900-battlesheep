import '../enums/avatar.dart';

class AvatarAssets {
  static const String path = 'assets/images/avatars';

  static String avatarPath(Avatar avatar) => switch (avatar) {
        Avatar.dmitry => '$path/dmitryFull.png',
        Avatar.georgie => '$path/georgieFull.png',
        Avatar.gorkina => '$path/gorkinaFull.png',
        Avatar.irina => '$path/irinaFull.png',
        Avatar.ivanov => '$path/ivanovFull.png',
        Avatar.ladeve => '$path/ladeveFull.png',
        Avatar.misha => '$path/mishaFull.png',
        Avatar.petrov => '$path/petrovFull.png',
        Avatar.sergei => '$path/sergeiFull.png',
        Avatar.sokolov => '$path/sokolovFull.png',
        Avatar.viktor => '$path/viktorFull.png',
        Avatar.volkov => '$path/volkovFull.png',
      };
}
