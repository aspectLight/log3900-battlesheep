class JoinGameSessionQrPayloadParser {
  JoinGameSessionQrPayloadParser._();

  static final RegExp _exactFourDigits = RegExp(r'^\d{4}$');
  static final RegExp _fourDigitToken = RegExp(r'\b\d{4}\b');

  static String? tryParseRoomCode(String raw) {
    final String trimmed = raw.trim();
    if (_exactFourDigits.hasMatch(trimmed)) {
      return trimmed;
    }
    final RegExpMatch? match = _fourDigitToken.firstMatch(trimmed);
    return match?.group(0);
  }
}
