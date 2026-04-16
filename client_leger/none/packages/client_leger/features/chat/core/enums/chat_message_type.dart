enum ChatMessageType {
  textSent,
  textReceived,
  emojiSent,
  emojiReceived;

  bool get isEmoji =>
      this == ChatMessageType.emojiSent ||
      this == ChatMessageType.emojiReceived;

  static ChatMessageType fromString(String value) {
    return switch (value) {
      'emoji-sent' => ChatMessageType.emojiSent,
      'emoji-received' => ChatMessageType.emojiReceived,
      'text-sent' => ChatMessageType.textSent,
      'text-received' => ChatMessageType.textReceived,
      _ => ChatMessageType.textSent,
    };
  }
}
