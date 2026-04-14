import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/enums/chat_message_type.dart';

part 'chat_message.freezed.dart';

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required ChatMessageType type,
    required String name,
    required String content,
    required String time,
    String? avatarId,
    String? avatarUrl,
  }) = _ChatMessage;
}
