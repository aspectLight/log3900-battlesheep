import 'package:flutter/foundation.dart';

import '../../../domain/entities/game_history_item.dart';
import '../../../domain/interfaces/repositories/game_history_repository.dart';

class GameHistoryViewModel extends ChangeNotifier {
  final GameHistoryRepository _repository;

  List<GameHistoryItem> items = [];
  bool isLoading = true;
  String? errorMessage;

  GameHistoryViewModel(this._repository);

  Future<void> loadHistory() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _repository.getGameHistory().run();

    result.fold(
      (failure) => errorMessage = failure.message,
      (data) => items = data,
    );

    isLoading = false;
    notifyListeners();
  }
}
