import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/chat_message.dart';

part 'chat_events.freezed.dart';

@freezed
class ChatMessageAddedEvent with _$ChatMessageAddedEvent {
  const factory ChatMessageAddedEvent(ChatMessage message) =
      _ChatMessageAddedEvent;
}

@freezed
class ChatHistorySetEvent with _$ChatHistorySetEvent {
  const factory ChatHistorySetEvent(List<ChatMessage> messages) =
      _ChatHistorySetEvent;
}
