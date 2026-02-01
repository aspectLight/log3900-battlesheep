import '../../domain/entities/chat_message_entity.dart';

class ChatMessageDto {
  final String type;
  final String? name;
  final String content;
  final String time;
  final bool isMe;

  ChatMessageDto({
    required this.type,
    this.name,
    required this.content,
    required this.time,
    required this.isMe,
  });

  factory ChatMessageDto.fromJson(Map<String, dynamic> json) {
    return ChatMessageDto(
      type: json['type'] as String,
      name: json['name'] as String?,
      content: json['content'] as String,
      time: json['time'] as String,
      isMe: json['isMe'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      if (name != null) 'name': name,
      'content': content,
      'time': time,
      'isMe': isMe,
    };
  }

  factory ChatMessageDto.fromEntity(ChatMessageEntity entity) {
    return ChatMessageDto(
      type: entity.type,
      name: entity.name,
      content: entity.content,
      time: entity.time,
      isMe: entity.isMe,
    );
  }
}
