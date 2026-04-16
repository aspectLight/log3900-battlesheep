import 'package:signals_flutter/signals_flutter.dart';

import '../../core/enums/board_interaction_mode.dart';

class GameBoardInteractionRepository {
  final Signal<BoardInteractionMode> state = signal(BoardInteractionMode.idle);

  void setMode(BoardInteractionMode mode) {
    state.value = mode;
  }

  void leaveInteraction() {
    state.value = BoardInteractionMode.idle;
  }

  void enterSelectionMode() {
    state.value = BoardInteractionMode.selection;
  }

  void enterActionMode() {
    state.value = BoardInteractionMode.action;
  }

  void toggleSelectionMode() {
    if (state.value == BoardInteractionMode.selection) {
      leaveInteraction();
      return;
    }
    enterSelectionMode();
  }

  void toggleActionMode() {
    if (state.value == BoardInteractionMode.action) {
      leaveInteraction();
      return;
    }
    enterActionMode();
  }

  void toggleActionModeOrReturnToSelection() {
    if (state.value == BoardInteractionMode.action) {
      enterSelectionMode();
    } else {
      enterActionMode();
    }
  }
}
