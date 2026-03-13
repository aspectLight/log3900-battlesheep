import 'package:signals_flutter/signals_flutter.dart';

import '../../domain/commands/session_commands.dart';
import '../../domain/state/session_state.dart';

class SessionRepository {
  final Signal<SessionState> state = signal(const SessionState.initial());

  SessionRepository();

  void setSessionState(SetSessionStateCommand command) {
    state.value = command.sessionState;
  }
}
