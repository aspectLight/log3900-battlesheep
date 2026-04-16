import 'package:get_it/get_it.dart';

import '../../../../core/modal/modal_widget_registry.dart';
import '../../presentation/widgets/select_game_session_modal/select_game_session_game_preview_modal_content.dart';
import '../modal/select_game_session_modal_intents.dart';

void registerSelectGameSessionModals(GetIt getIt) {
  final registry = getIt<ModalWidgetRegistry>();
  registry.register<SelectGameSessionGamePreviewModalIntent>(
    (context, intent, onClose) => SelectGameSessionGamePreviewModalContent(
      intent: intent,
      onClose: onClose,
    ),
  );
}
