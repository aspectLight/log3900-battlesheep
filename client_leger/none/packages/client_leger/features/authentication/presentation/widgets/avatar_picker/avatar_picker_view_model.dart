import 'package:fpdart/fpdart.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/enums/auth_avatar.dart';

class AvatarPickerViewModel {
  final selectedAvatar = signal<Option<AuthAvatar>>(const Option.none());

  List<AuthAvatar> get avatars => AuthAvatar.values
      .where((avatar) => !avatar.isExclusiveAtSignUp)
      .toList(growable: false);

  bool isSelected(AuthAvatar avatar) =>
      selectedAvatar.value.fold(() => false, (s) => s == avatar);

  void selectAvatar(AuthAvatar avatar) {
    selectedAvatar.value = Option.of(avatar);
  }

  void reset() {
    selectedAvatar.value = const Option.none();
  }

  void dispose() {
    selectedAvatar.dispose();
  }
}
