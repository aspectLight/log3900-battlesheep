import '../../../domain/commands/chat_commands.dart';
import '../dto/send_message_payload_dto.dart';

extension SendChatMessageCommandToDto on SendChatMessageCommand {
  SendMessagePayloadDto toSendMessagePayloadDto() =>
      SendMessagePayloadDto(username: username, message: content);
}
