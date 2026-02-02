import '../../domain/entities/chat_message_entity.dart';

class UiChatMessage {
  final String type;
  final String? name;
  final String content;
  final String time;
  final bool isMe;

  const UiChatMessage({
    required this.type,
    this.name,
    required this.content,
    required this.time,
    required this.isMe,
  });

  factory UiChatMessage.fromEntity(
    ChatMessageEntity entity,
    String? currentUsername,
  ) {
    return UiChatMessage(
      type: entity.type,
      name: entity.name,
      content: entity.content,
      time: entity.time,
      isMe: entity.name == currentUsername,
    );
  }
}
