import 'package:signals_flutter/signals_flutter.dart';

import '../../../../core/constants/auth_avatar_assets.dart';
import '../../../../core/enums/auth_avatar.dart';

class AvatarPickerViewModel {
  final selectedAvatarId = signal<String?>(null);

  List<String> get avatarPaths =>
      AuthAvatar.values.map(AuthAvatarAssets.assetPath).toList();

  List<String> get avatarIds =>
      AuthAvatar.values.map((a) => a.id).toList();

  void selectAvatar(String id) {
    selectedAvatarId.value = id;
  }

  void reset() {
    selectedAvatarId.value = null;
  }

  void dispose() {
    selectedAvatarId.dispose();
  }
}
