import '../../../core/enums/stat_type.dart';

class GamePlayerUiStat {
  final StatType statType;
  final int value;
  final String assetPath;

  const GamePlayerUiStat({
    required this.statType,
    required this.value,
    required this.assetPath,
  });
}
