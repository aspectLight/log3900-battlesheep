import 'package:get_it/get_it.dart';

import '../../../../core/modal/modal_widget_registry.dart';
import '../../presentation/widgets/profile_modal/profile_popup_modal_content.dart';
import '../modal/profile_modal_intents.dart';

void registerProfileModals(GetIt getIt) {
  final registry = getIt<ModalWidgetRegistry>();
  registry.register<ProfilePopupModalIntent>(
    (context, intent, onClose) =>
        ProfilePopupModalContent(intent: intent, onClose: onClose),
  );
}
