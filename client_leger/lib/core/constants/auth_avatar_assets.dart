import '../enums/auth_avatar.dart';
import 'ui_assets.dart';

class AuthAvatarAssets {
  static const String _base = 'assets/images/auth_avatars';

  /// Known account-creation preset only; `null` if [avatarId] is not one of them.
  static String? tryAssetPathForAvatarId(String avatarId) {
    for (final a in AuthAvatar.values) {
      if (a.id == avatarId) return assetPath(a);
    }
    return null;
  }

  static String assetPathForAvatarId(String avatarId) {
    return tryAssetPathForAvatarId(avatarId) ??
        UiAssets.characterCreationEmptyPortrait;
  }

  static String assetPath(AuthAvatar avatar) => switch (avatar) {
    AuthAvatar.esportsGamer => '$_base/esports-gamer.png',
    AuthAvatar.raceCarDriver => '$_base/race-car-driver.png',
    AuthAvatar.cyberpunkTechie => '$_base/cyberpunk-techie.png',
    AuthAvatar.secretAgent => '$_base/secret-agent.png',
    AuthAvatar.survivalist => '$_base/survivalist.png',
    AuthAvatar.dj => '$_base/dj.png',
    AuthAvatar.skateboarder => '$_base/skateboarder.png',
    AuthAvatar.mechanic => '$_base/mechanic.png',
    AuthAvatar.detective => '$_base/detective.png',
    AuthAvatar.streetFighter => '$_base/street-fighter.png',
    AuthAvatar.tacticalOperator => '$_base/tactical-operator.png',
    AuthAvatar.screamGhostface => '$_base/scream-ghostface.png',
  };
}
