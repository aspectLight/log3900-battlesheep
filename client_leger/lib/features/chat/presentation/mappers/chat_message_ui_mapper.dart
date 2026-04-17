import '../ui_models/chat_message_ui.dart';
import '../../domain/models/chat_message.dart';

ChatMessageUi toChatMessageUi(
  ChatMessage entity, {
  required String currentUsername,
  String? displayAvatarId,
  String? displayAvatarUrl,
  int? avatarDisplayNonce,
}) {
  return ChatMessageUi(
    type: entity.type,
    name: entity.name,
    content: entity.content,
    time: entity.time,
    isMe: entity.name == currentUsername,
    avatarId: displayAvatarId ?? entity.avatarId,
    avatarUrl: displayAvatarUrl ?? entity.avatarUrl,
    avatarDisplayNonce: avatarDisplayNonce,
  );
}
