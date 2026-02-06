import 'package:signals_flutter/signals_flutter.dart';

import '../../../../core/constants/asset_constants.dart';

class AvatarPickerViewModel {
  final selectedAvatarId = signal<String?>(null);

  List<String> get avatarPaths => AssetConstants.avatarPaths;
  List<String> get avatarIds => AssetConstants.avatarIds;

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
