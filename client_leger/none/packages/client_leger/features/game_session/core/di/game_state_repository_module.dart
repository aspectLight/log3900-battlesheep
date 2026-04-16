import 'package:get_it/get_it.dart';

import '../../data/repositories/game_board_interaction_repository.dart';
import '../../data/repositories/game_board_repository.dart';
import '../../data/repositories/game_board_selected_cell_repository.dart';
import '../../data/repositories/game_inventory_repository.dart';
import '../../data/repositories/game_player_repository.dart';
import '../../data/repositories/game_turn_repository.dart';
import '../../data/services/game_board_socket.dart';
import '../../domain/models/game.dart';
import '../../domain/state/game_board_state.dart';

void registerGameStateRepositories(GetIt scope) {
  scope.registerLazySingleton<GameTurnRepository>(
    () => GameTurnRepository(reducer: scope.get()),
  );
  final game = scope.get<Game>();
  scope.registerLazySingleton<GameBoardRepository>(
    () => GameBoardRepository(
      initialState: GameBoardState.scopedInitial(
        board: scope.get<Board>(),
        items: game.initialItems,
      ),
      reducer: scope.get(),
      boardSocket: scope.get<GameBoardSocket>(),
    ),
  );
  scope.registerLazySingleton<GameBoardInteractionRepository>(
    GameBoardInteractionRepository.new,
  );
  scope.registerLazySingleton<GameBoardSelectedCellRepository>(
    GameBoardSelectedCellRepository.new,
  );
  scope.registerLazySingleton<GamePlayerRepository>(
    () => GamePlayerRepository(reducer: scope.get()),
  );
  scope.registerLazySingleton<GameInventoryRepository>(
    () => GameInventoryRepository(reducer: scope.get()),
  );
}
