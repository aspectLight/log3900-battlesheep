import 'package:fpdart/fpdart.dart';
import 'package:signals_flutter/signals_flutter.dart';

class ChatPanelStateRepository {
  final Signal<Option<String>> lastSentMessage = signal(const Option.none());
  final Signal<int> selectedEmojiIndex = signal(0);

  void setLastSentMessage(Option<String> value) {
    lastSentMessage.value = value;
  }

  void setSelectedEmojiIndex(int index) {
    selectedEmojiIndex.value = index;
  }
}
