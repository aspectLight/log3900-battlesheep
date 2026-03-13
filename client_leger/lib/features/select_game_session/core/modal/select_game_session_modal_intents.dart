import '../../../../core/modal/modal_intent.dart';

class SelectGameSessionGamePreviewModalIntent extends ModalIntent {
  const SelectGameSessionGamePreviewModalIntent({
    required this.description,
    required this.imagePath,
  });

  final String description;
  final String imagePath;
}
