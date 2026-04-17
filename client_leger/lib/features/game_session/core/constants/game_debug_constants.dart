abstract final class GameDebugConstants {
  /// Min |accel| along **display** top-to-bottom (landscape app → device X); raw like chat.
  static const double shakeThresholdVertical = 14;
  static const double shakeDeadZone = 14;

  static const int shakeMinIntervalMs = 950;
  static const int shakeSequenceWindowMs = 12000;
  static const int shakesRequiredCount = 3;
}
