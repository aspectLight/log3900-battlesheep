import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_commands.freezed.dart';

@freezed
class SendChatMessageCommand with _$SendChatMessageCommand {
  const factory SendChatMessageCommand({
    required String username,
    required String content,
  }) = _SendChatMessageCommand;
}

@freezed
class SendChatEmojiCommand with _$SendChatEmojiCommand {
  const factory SendChatEmojiCommand({
    required String username,
    required String emoji,
  }) = _SendChatEmojiCommand;
}
