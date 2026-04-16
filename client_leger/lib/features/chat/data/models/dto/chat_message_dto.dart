class ChatMessageDto {
  final String type;
  final String name;
  final String content;
  final String time;
  final String? avatarId;
  final String? avatarUrl;

  const ChatMessageDto({
    required this.type,
    required this.name,
    required this.content,
    required this.time,
    this.avatarId,
    this.avatarUrl,
  });

  factory ChatMessageDto.fromJson(Map<String, dynamic> json) {
    final Object? type = json['type'];
    final Object? name = json['name'];
    final Object? content = json['content'];
    final Object? time = json['time'];
    final Object? avatarId = json['avatarId'];
    final Object? avatarUrl = json['avatarUrl'];
    return ChatMessageDto(
      type: type is String ? type : '',
      name: name is String ? name : '',
      content: content is String ? content : '',
      time: time is String ? time : '',
      avatarId: avatarId is String ? avatarId : null,
      avatarUrl: avatarUrl is String ? avatarUrl : null,
    );
  }

  factory ChatMessageDto.fromSocketPayload(Object? data) {
    if (data is Map) {
      return ChatMessageDto.fromJson(Map<String, dynamic>.from(data));
    }
    return const ChatMessageDto(type: '', name: '', content: '', time: '');
  }

  static List<ChatMessageDto> listFromSocketPayload(Object? data) {
    final Object? raw;
    if (data is List<dynamic>) {
      raw = data;
    } else if (data is Map) {
      raw = data['messages'];
    } else {
      raw = null;
    }
    if (raw is! List<dynamic>) return const <ChatMessageDto>[];
    return raw
        .whereType<Map>()
        .map((e) => ChatMessageDto.fromJson(Map<String, dynamic>.from(e)))
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
    'avatarId': avatarId,
    'avatarUrl': avatarUrl,
  };
}
