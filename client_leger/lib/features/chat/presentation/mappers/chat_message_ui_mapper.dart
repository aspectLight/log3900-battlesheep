import '../ui_models/chat_message_ui.dart';
import '../../domain/models/chat_message.dart';

ChatMessageUi toChatMessageUi(
  ChatMessage entity, {
  required String currentUsername,
}) {
  return ChatMessageUi(
    type: entity.type,
    name: entity.name,
    content: entity.content,
    time: entity.time,
    isMe: entity.name == currentUsername,
  );
}
