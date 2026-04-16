import '../../../../../core/constants/ui_assets.dart';
import '../../../../../core/enums/character.dart';
import '../../../domain/models/waiting_room_player_model.dart';
import '../dto/waiting_room_player_dto.dart';
import 'waiting_room_player_stats_dto_extensions.dart';

extension AvatarPayloadToCharacter on Map<String, dynamic> {
  Character toCharacter() {
    final name = this['name'] as String?;
    if (name != null && name.isNotEmpty) return Character.fromAvatarName(name);
    final path = this['avatarFull'] as String?;
    if (path != null && path.isNotEmpty) {
      final nameFromPath = _characterNameFromAvatarPath(path);
      if (nameFromPath != null && nameFromPath.isNotEmpty) {
        return Character.fromAvatarName(nameFromPath);
      }
    }
    return Character.dmitry;
  }
}

String? _characterNameFromAvatarPath(String path) {
  final segments = path.split(RegExp(r'[/\\]'));
  final filename = segments.isNotEmpty ? segments.last : '';
  if (filename.toLowerCase().endsWith('Full.png'.toLowerCase())) {
    return filename.substring(0, filename.length - 'Full.png'.length);
  }
  if (filename.endsWith('.png')) {
    return filename.substring(0, filename.length - 4);
  }
  return filename.isNotEmpty ? filename : null;
}

bool _hasValidAvatar(Map<String, dynamic>? avatar) {
  if (avatar == null) return false;
  final name = avatar['name'] as String?;
  if (name != null && name.isNotEmpty) return true;
  final path = avatar['avatarFull'] as String?;
  return path != null && path.isNotEmpty;
}

extension WaitingRoomPlayerDtoToModel on WaitingRoomPlayerDto {
  WaitingRoomPlayerModel toModel() {
    final character = (avatar ?? const {}).toCharacter();
    final hasValid = _hasValidAvatar(avatar);
    final avatarDisplayPath = hasValid
        ? null
        : UiAssets.characterCreationEmptyPortrait;
    if (!isVirtual) {
      return WaitingRoomPlayerModel.human(
        id: id,
        name: name,
        character: character,
        stats: stats.toModel(),
        avatarDisplayPath: avatarDisplayPath,
        profileAvatarId: profileAvatarId,
        profileAvatarUrl: profileAvatarUrl,
        activeBanner: activeBanner,
      );
    }
    return WaitingRoomPlayerModel.virtual(
      id: id,
      name: name,
      character: character,
      stats: stats.toModel(),
      virtualType: virtualType,
      d6Choice: d6Choice,
      d4Choice: d4Choice,
      avatarDisplayPath: avatarDisplayPath,
      profileAvatarId: profileAvatarId,
      profileAvatarUrl: profileAvatarUrl,
      activeBanner: activeBanner,
    );
  }
}
