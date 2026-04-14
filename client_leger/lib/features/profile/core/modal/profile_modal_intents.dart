import '../../../../core/modal/modal_intent.dart';

class ProfilePopupModalIntent extends ModalIntent {
  const ProfilePopupModalIntent({
    required this.title,
    required this.description,
    required this.primaryLabel,
    required this.onPrimaryAction,
    this.secondaryLabel,
    this.onSecondaryAction,
    this.isError = false,
    this.modalKey,
  });

  final String title;
  final String description;
  final String primaryLabel;
  final void Function() onPrimaryAction;
  final String? secondaryLabel;
  final void Function()? onSecondaryAction;
  final bool isError;
  final String? modalKey;
}
