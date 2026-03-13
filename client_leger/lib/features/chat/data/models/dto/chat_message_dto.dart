class ChatMessageDto {
  final String type;
  final String name;
  final String content;
  final String time;

  const ChatMessageDto({
    required this.type,
    required this.name,
    required this.content,
    required this.time,
  });

  factory ChatMessageDto.fromJson(Map<String, dynamic> json) {
    final Object? type = json['type'];
    final Object? name = json['name'];
    final Object? content = json['content'];
    final Object? time = json['time'];
    return ChatMessageDto(
      type: type is String ? type : '',
      name: name is String ? name : '',
      content: content is String ? content : '',
      time: time is String ? time : '',
    );
  }

  factory ChatMessageDto.fromSocketPayload(Object? data) {
    if (data is Map<String, dynamic>) return ChatMessageDto.fromJson(data);
    return const ChatMessageDto(type: '', name: '', content: '', time: '');
  }

  static List<ChatMessageDto> listFromSocketPayload(Object? data) {
    final Object? raw = switch (data) {
      final List<dynamic> list => list,
      final Map<String, dynamic> map => map['messages'],
      _ => null,
    };
    if (raw is! List<dynamic>) return const <ChatMessageDto>[];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(ChatMessageDto.fromJson)
        .where(
          (m) =>
              m.type.isNotEmpty &&
              m.name.isNotEmpty &&
              m.content.isNotEmpty &&
              m.time.isNotEmpty,
        )
        .toList();
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'type': type,
    'name': name,
    'content': content,
    'time': time,
  };
}
