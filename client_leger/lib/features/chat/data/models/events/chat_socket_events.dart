abstract class GeneralChatEvents {
  GeneralChatEvents._();

  static const String joinGeneralChat = 'joinGeneralChat';
  static const String getGeneralChatMessages = 'getGeneralChatMessages';
  static const String sendMessageToGeneralChat = 'sendMessageToGeneralChat';
  static const String sendEmojiToGeneralChat = 'sendEmojiToGeneralChat';

  static const String getGeneralChatMessagesResponse =
      'getGeneralChatMessagesResponse';
  static const String generalChatMessage = 'generalChatMessage';
  static const String generalChatEmoji = 'generalChatEmoji';

  static const String avatarUpdated = 'avatarUpdated';
}
