import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/enums/chat_message_type.dart';

part 'chat_message_ui.freezed.dart';

@freezed
class ChatMessageUi with _$ChatMessageUi {
  const factory ChatMessageUi({
    required ChatMessageType type,
    required String name,
    required String content,
    required String time,
    required bool isMe,
    String? avatarId,
    String? avatarUrl,
  }) = _ChatMessageUi;
}
