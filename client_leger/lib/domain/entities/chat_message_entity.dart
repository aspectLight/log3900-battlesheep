class ChatMessageEntity {
  final String type;
  final String? name;
  final String content;
  final String time;
  final bool isMe;

  ChatMessageEntity({
    required this.type,
    this.name,
    required this.content,
    required this.time,
    required this.isMe,
  });
}
