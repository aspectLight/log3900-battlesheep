import '../../domain/entities/chat_message_entity.dart';

class ChatUiMessage {
  final String type;
  final String? name;
  final String content;
  final String time;
  final bool isMe;

  const ChatUiMessage({
    required this.type,
    this.name,
    required this.content,
    required this.time,
    required this.isMe,
  });

  factory ChatUiMessage.fromEntity(
    ChatMessageEntity entity, {
    required String currentUsername,
  }) {
    return ChatUiMessage(
      type: entity.type,
      name: entity.name,
      content: entity.content,
      time: entity.time,
      isMe: entity.name == currentUsername,
    );
  }

  bool get isEmoji => type == 'emoji-sent' || type == 'emoji-received';
}
