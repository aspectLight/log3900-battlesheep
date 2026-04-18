class ChatConstants {
  ChatConstants._();

  static const int messageMaxLength = 100;
  /// Raw accelerometer; aligned with debug shake tuning (debug −1).
  static const double shakeThresholdVertical = 13;
  static const double shakeThresholdHorizontal = 13;
  static const double shakeDeadZone = 13;
  static const int shakeCooldownMs = 949;
  static const List<String> defaultEmojis = ['👍', '❤️', '😂', '😮'];
}
