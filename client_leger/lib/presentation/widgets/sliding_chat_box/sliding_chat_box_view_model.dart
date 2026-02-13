import 'package:signals_flutter/signals_flutter.dart';

class SlidingChatBoxViewModel {
  final Signal<bool> isExpanded = signal(false);

  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }

  void dispose() {}
}
