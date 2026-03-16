import 'package:get_it/get_it.dart';

import '../../data/reducers/game_board_state_reducer.dart';
import '../../data/reducers/game_combat_state_reducer.dart';
import '../../data/reducers/game_inventory_state_reducer.dart';
import '../../data/reducers/game_metadata_state_reducer.dart';
import '../../data/reducers/game_player_state_reducer.dart';
import '../../data/reducers/game_turn_state_reducer.dart';

void registerGameReducers(GetIt getIt) {
  getIt.registerLazySingleton<GameTurnStateReducer>(GameTurnStateReducer.new);
  getIt.registerLazySingleton<GameBoardStateReducer>(GameBoardStateReducer.new);
  getIt.registerLazySingleton<GamePlayerStateReducer>(
    GamePlayerStateReducer.new,
  );
  getIt.registerLazySingleton<GameCombatStateReducer>(
    GameCombatStateReducer.new,
  );
  getIt.registerLazySingleton<GameInventoryStateReducer>(
    GameInventoryStateReducer.new,
  );
  getIt.registerLazySingleton<GameMetadataStateReducer>(
    GameMetadataStateReducer.new,
  );
}
