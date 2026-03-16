import 'package:signals_flutter/signals_flutter.dart';

import '../../../data/repositories/game_debug_repository.dart';

class GameDebugModeStripViewModel {
  GameDebugModeStripViewModel({required GameDebugRepository debugRepository})
    : _debugRepository = debugRepository;

  final GameDebugRepository _debugRepository;

  Computed<bool> get isDebugMode => computed(() {
    return _debugRepository.state.value.isDebugMode;
  });
}
