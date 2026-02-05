import '../../domain/entities/chat_message_entity.dart';

class ChatMessageDto {
  final String type;
  final String? name;
  final String content;
  final String time;

  const ChatMessageDto({
    required this.type,
    this.name,
    required this.content,
    required this.time,
  });

  factory ChatMessageDto.fromSocketData(Map<String, dynamic> data) {
    return ChatMessageDto(
      type: data['type'] as String? ?? 'received',
      name: data['name'] as String?,
      content: data['content'] as String? ?? data['message'] as String? ?? '',
      time: data['time'] as String? ?? '',
    );
  }

  factory ChatMessageDto.fromJson(Map<String, dynamic> json) {
    return ChatMessageDto(
      type: json['type'] as String,
      name: json['name'] as String?,
      content: json['content'] as String,
      time: json['time'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      if (name != null) 'name': name,
      'content': content,
      'time': time,
    };
  }

  ChatMessageEntity toEntity() {
    return ChatMessageEntity(
      type: type,
      name: name,
      content: content,
      time: time,
    );
  }
}
