import 'package:get_it/get_it.dart';

import '../../../../core/app_transition/auto_scope_coordinator.dart';
import '../../../../core/connected_scope/session_scope_manager.dart';
import '../../data/services/chat_socket.dart';
import '../app_events/chat_events.dart';
import '../context/chat_data.dart';
import '../context/chat_scope_holder.dart';
import '../di/chat_module.dart';

class ChatCoordinator
    extends
        AutoScopeCoordinator<
          ChatData,
          ChatEntryAppEvent,
          ChatCompletedAppEvent,
          ChatExitAppEvent
        > {
  ChatCoordinator({
    required this.getIt,
    required this.sessionScopeManager,
    required this.chatScopeHolder,
  });

  final GetIt getIt;
  @override
  final SessionScopeManager sessionScopeManager;
  final ChatScopeHolder chatScopeHolder;

  @override
  final String scopeName = 'chat';

  @override
  void onScopeCreated(GetIt scope) {
    registerChatScope(scope, getIt, username: entryData.username);
  }

  @override
  Future<ChatData?> onEntryImpl(ChatEntryAppEvent event) async {
    switch (event) {
      case ChatEnterAfterAuth(:final username):
        return ChatData(username: username);
    }
  }

  @override
  Future<void> onCompletedImpl(
    ChatCompletedAppEvent event,
    ChatData data,
  ) async {
    final scope = featureScope;
    if (scope == null) return;
    bootstrapChatScope(scope);
    scope.get<ChatSocket>().join(data.username);
    chatScopeHolder.setScope(scope);
  }

  @override
  Future<void> onExitImpl(ChatExitAppEvent event, ChatData data) async {
    chatScopeHolder.clearScope();
  }
}
