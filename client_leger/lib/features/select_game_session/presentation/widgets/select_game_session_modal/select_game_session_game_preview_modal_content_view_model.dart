import '../../../core/modal/select_game_session_modal_intents.dart';

class SelectGameSessionGamePreviewModalContentViewModel {
  SelectGameSessionGamePreviewModalContentViewModel({
    required this.intent,
    required this.onClose,
  });

  final SelectGameSessionGamePreviewModalIntent intent;
  final void Function() onClose;

  void close() => onClose();
}
