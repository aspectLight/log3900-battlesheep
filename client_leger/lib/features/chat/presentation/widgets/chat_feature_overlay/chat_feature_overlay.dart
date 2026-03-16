import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/di/injection_container.dart';
import '../../../core/context/chat_scope_holder.dart';
import '../../../core/event_bus/chat_event_bus.dart';
import '../chat_panel_content/chat_panel_content_view_model.dart';
import '../sliding_chat_box/sliding_chat_box.dart';
import '../sliding_chat_box/sliding_chat_box_view_model.dart';

class ChatFeatureOverlay extends StatelessWidget {
  const ChatFeatureOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final chatScopeHolder = getIt<ChatScopeHolder>();
      final isChatAvailable = chatScopeHolder.isChatAvailable.watch(context);

      if (!isChatAvailable) {
        return const SizedBox.shrink();
      }

      final scope = chatScopeHolder.scope!;

      return SlidingChatBox(
        viewModel: scope.get<SlidingChatBoxViewModel>(),
        chatPanelContentViewModel: scope.get<ChatPanelContentViewModel>(),
        chatEventBus: scope.get<ChatEventBus>(),
      );
    });
  }
}
