import 'package:signals_flutter/signals_flutter.dart';

enum ChatTab { chat, journal }

class SlidingChatBoxViewModel {
  final Signal<bool> isExpanded = signal(false);
  final Signal<ChatTab> activeTab = signal(ChatTab.chat);

  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }

  void setTab(ChatTab tab) {
    activeTab.value = tab;
  }

  void dispose() {}
}
