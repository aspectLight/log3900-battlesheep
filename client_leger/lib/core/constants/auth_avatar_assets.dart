import '../enums/auth_avatar.dart';

class AuthAvatarAssets {
  static const String _base = 'assets/images/auth_avatars';

  static String assetPath(AuthAvatar avatar) => switch (avatar) {
        AuthAvatar.usNavySEAL => '$_base/USNavySEAL.png',
        AuthAvatar.agentSpetsnaz => '$_base/agentSpetsnaz.png',
        AuthAvatar.commandoSAS => '$_base/commandoSAS.png',
        AuthAvatar.gardeFrontiere => '$_base/garde-frontiere.png',
        AuthAvatar.milicien => '$_base/milicien.png',
        AuthAvatar.officierAllemand => '$_base/officierAllemand.png',
        AuthAvatar.operateurRadio => '$_base/operateurRadio.png',
        AuthAvatar.parachutiste => '$_base/parachutiste.png',
        AuthAvatar.pilote => '$_base/pilote.png',
        AuthAvatar.sergent => '$_base/sergent.png',
        AuthAvatar.specialisteSovietique => '$_base/specialisteSovietique.png',
        AuthAvatar.tankiste => '$_base/tankiste.png',
      };
}
