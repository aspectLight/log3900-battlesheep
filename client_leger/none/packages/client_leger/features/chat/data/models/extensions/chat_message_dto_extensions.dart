import '../../../core/enums/chat_message_type.dart';
import '../../../domain/models/chat_message.dart';
import '../dto/chat_message_dto.dart';

extension ChatMessageDtoToModel on ChatMessageDto {
  ChatMessage toModel() => ChatMessage(
    type: ChatMessageType.fromString(type),
    name: name,
    content: content,
    time: time,
    avatarId: avatarId,
    avatarUrl: avatarUrl,
  );
}
