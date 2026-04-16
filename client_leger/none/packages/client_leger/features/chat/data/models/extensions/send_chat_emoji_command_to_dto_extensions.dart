import '../../../domain/commands/chat_commands.dart';
import '../dto/send_emoji_payload_dto.dart';

extension SendChatEmojiCommandToDto on SendChatEmojiCommand {
  SendEmojiPayloadDto toSendEmojiPayloadDto() =>
      SendEmojiPayloadDto(username: username, emoji: emoji);
}
