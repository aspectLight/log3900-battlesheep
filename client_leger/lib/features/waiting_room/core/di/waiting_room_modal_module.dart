import 'package:get_it/get_it.dart';

import '../../../../core/modal/modal_widget_registry.dart';
import '../../presentation/widgets/waiting_room_modal/waiting_room_confirm_kick_modal_content.dart';
import '../../presentation/widgets/waiting_room_modal/waiting_room_confirm_leave_modal_content.dart';
import '../../presentation/widgets/waiting_room_modal/waiting_room_confirm_unlock_modal_content.dart';
import '../../presentation/widgets/waiting_room_modal/waiting_room_select_virtual_profile_modal_content.dart';
import '../modal/waiting_room_modal_intents.dart';

void registerWaitingRoomModals(GetIt getIt) {
  final registry = getIt<ModalWidgetRegistry>();
  registry.register<WaitingRoomConfirmLeaveModalIntent>(
    (context, intent, onClose) => WaitingRoomConfirmLeaveModalContent(
      intent: intent,
      onClose: onClose,
    ),
  );
  registry.register<WaitingRoomConfirmKickModalIntent>(
    (context, intent, onClose) => WaitingRoomConfirmKickModalContent(
      intent: intent,
      onClose: onClose,
    ),
  );
  registry.register<WaitingRoomConfirmUnlockModalIntent>(
    (context, intent, onClose) => WaitingRoomConfirmUnlockModalContent(
      intent: intent,
      onClose: onClose,
    ),
  );
  registry.register<WaitingRoomSelectVirtualProfileModalIntent>(
    (context, intent, onClose) => WaitingRoomSelectVirtualProfileModalContent(
      intent: intent,
      onClose: onClose,
    ),
  );
}
