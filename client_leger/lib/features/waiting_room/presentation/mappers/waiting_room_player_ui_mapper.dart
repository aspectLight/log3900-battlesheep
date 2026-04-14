import '../../../../core/constants/character_assets.dart';
import '../../domain/models/waiting_room_player_model.dart';
import '../ui_models/components/waiting_room_player_ui.dart';

WaitingRoomPlayerUi toWaitingRoomPlayerUi(WaitingRoomPlayerModel model) {
  return switch (model) {
    HumanWaitingRoomPlayerModel(
      :final id,
      :final name,
      :final character,
      :final stats,
      :final avatarDisplayPath,
      :final profileAvatarId,
      :final profileAvatarUrl,
      :final activeBanner,
    ) =>
      WaitingRoomPlayerUi(
        id: id,
        name: name,
        avatarFullPath:
            avatarDisplayPath ??
            CharacterAssets.characterAvatarFullPath(character),
        profileAvatarId: profileAvatarId,
        profileAvatarUrl: profileAvatarUrl,
        isVirtual: false,
        health: stats.health.value,
        speed: stats.speed.value,
        attack: stats.attack.value,
        defense: stats.defense.value,
        activeBanner: activeBanner,
      ),
    VirtualWaitingRoomPlayerModel(
      :final id,
      :final name,
      :final character,
      :final stats,
      :final avatarDisplayPath,
      :final profileAvatarId,
      :final profileAvatarUrl,
      :final activeBanner,
    ) =>
      WaitingRoomPlayerUi(
        id: id,
        name: name,
        avatarFullPath:
            avatarDisplayPath ??
            CharacterAssets.characterAvatarFullPath(character),
        profileAvatarId: profileAvatarId,
        profileAvatarUrl: profileAvatarUrl,
        isVirtual: true,
        health: stats.health.value,
        speed: stats.speed.value,
        attack: stats.attack.value,
        defense: stats.defense.value,
        activeBanner: activeBanner,
      ),
  };
}
