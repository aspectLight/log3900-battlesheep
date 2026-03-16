class ChatConstants {
  ChatConstants._();

  static const int messageMaxLength = 100;
  static const double shakeThresholdVertical = 15;
  static const double shakeThresholdHorizontal = 15;
  static const double shakeDeadZone = 10;
  static const int shakeCooldownMs = 1000;
  static const List<String> defaultEmojis = ['👍', '❤️', '😂', '😮'];
}
