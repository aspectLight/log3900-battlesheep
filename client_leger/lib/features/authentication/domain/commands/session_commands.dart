import 'package:freezed_annotation/freezed_annotation.dart';

import '../state/session_state.dart';

part 'session_commands.freezed.dart';

@freezed
class SetSessionStateCommand with _$SetSessionStateCommand {
  const factory SetSessionStateCommand({
    required SessionState sessionState,
  }) = _SetSessionStateCommand;
}
