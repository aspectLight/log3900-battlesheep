import 'package:freezed_annotation/freezed_annotation.dart';

part 'select_game_session_commands.freezed.dart';

@freezed
class LoadGamesCommand with _$LoadGamesCommand {
  const factory LoadGamesCommand() = _LoadGamesCommand;
}

@freezed
class ConfirmSelectionCommand with _$ConfirmSelectionCommand {
  const factory ConfirmSelectionCommand({
    required String selectedGameId,
  }) = _ConfirmSelectionCommand;
}

