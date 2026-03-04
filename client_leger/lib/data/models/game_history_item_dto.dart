import '../../domain/entities/game_history_item.dart';

class GameHistoryItemDto {
  final String startDate;
  final String mode;
  final bool hasWon;
  final bool hasAbandoned;

  const GameHistoryItemDto({
    required this.startDate,
    required this.mode,
    required this.hasWon,
    required this.hasAbandoned,
  });

  factory GameHistoryItemDto.fromJson(Map<String, dynamic> json) {
    return GameHistoryItemDto(
      startDate: json['startDate'] as String,
      mode: json['mode'] as String,
      hasWon: json['hasWon'] as bool,
      hasAbandoned: json['hasAbandoned'] as bool,
    );
  }

  GameHistoryItem toEntity() => GameHistoryItem(
    startDate: DateTime.parse(startDate).toLocal(),
    mode: mode == 'CTF' ? GameMode.ctf : GameMode.classique,
    result: hasAbandoned
        ? GameResult.abandoned
        : hasWon
        ? GameResult.won
        : GameResult.lost,
  );
}
