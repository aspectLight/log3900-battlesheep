import '../../domain/models/character_creation_entry_mode.dart';

class CharacterCreationData {
  const CharacterCreationData({
    required this.roomCode,
    required this.socketId,
    required this.entryMode,
  });

  final String roomCode;
  final String socketId;
  final CharacterCreationEntryMode entryMode;
}
