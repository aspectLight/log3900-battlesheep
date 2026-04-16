import 'package:json_annotation/json_annotation.dart';

import '../enums/game_mode.dart';

class GameModeConverter implements JsonConverter<GameMode, String> {
  const GameModeConverter();

  @override
  GameMode fromJson(String json) {
    switch (json) {
      case 'classique':
        return GameMode.classic;
      case 'ctf':
        return GameMode.captureTheFlag;
    }
    throw ArgumentError('Unknown game mode: $json');
  }

  @override
  String toJson(GameMode object) {
    switch (object) {
      case GameMode.classic:
        return 'classique';
      case GameMode.captureTheFlag:
        return 'ctf';
    }
  }
}
