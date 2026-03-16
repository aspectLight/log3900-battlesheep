import 'package:fpdart/fpdart.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/enums/avatar.dart';

class AvatarPickerViewModel {
  final selectedAvatar = signal<Option<Avatar>>(const Option.none());

  List<Avatar> get avatars => Avatar.values;

  bool isSelected(Avatar avatar) =>
      selectedAvatar.value.fold(() => false, (s) => s == avatar);

  void selectAvatar(Avatar avatar) {
    selectedAvatar.value = Option.of(avatar);
  }

  void reset() {
    selectedAvatar.value = const Option.none();
  }

  void dispose() {
    selectedAvatar.dispose();
  }
}
